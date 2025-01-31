resource "helm_release" "karpenter" {
  namespace        = "karpenter"
  create_namespace = true

  name       = "karpenter"
  repository = "oci://public.ecr.aws/karpenter"
  chart      = "karpenter"
  version    = "v0.34.0"

  set {
    name  = "settings.aws.clusterName"
    value = var.cluster_name
  }

  set {
    name  = "serviceAccount.annotations.eks\\.amazonaws\\.com/role-arn"
    value = aws_iam_role.karpenter_controller.arn
  }

  set {
    name  = "settings.aws.defaultInstanceProfile"
    value = aws_iam_instance_profile.karpenter.name
  }

  # Significantly increased timeout
  timeout = 1800  # 30 minutes
  wait    = true

  # Additional debugging and reliability settings
  wait_for_jobs = true
  force_update  = true
  recreate_pods = true

  # Set debug logging
  set {
    name  = "logLevel"
    value = "debug"
  }
}

resource "null_resource" "install_karpenter_crds" {
  depends_on = [helm_release.karpenter]

  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f https://raw.githubusercontent.com/aws/karpenter/v0.34.0/pkg/apis/karpenter.sh/v1beta1/crds/karpenter.sh_provisioners.yaml
      kubectl apply -f https://raw.githubusercontent.com/aws/karpenter/v0.34.0/pkg/apis/karpenter.k8s.aws/v1beta1/crds/karpenter.k8s.aws_awsnodetemplates.yaml
    EOT
  }
}

resource "null_resource" "karpenter_node_template" {
  depends_on = [null_resource.install_karpenter_crds]

  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f - <<EOF
      apiVersion: karpenter.k8s.aws/v1alpha1
      kind: AWSNodeTemplate
      metadata:
        name: default
        namespace: karpenter
      spec:
        subnetSelector:
          karpenter.sh/discovery: ${var.cluster_name}
        securityGroupSelector:
          karpenter.sh/discovery: ${var.cluster_name}
        instanceProfile: karpenter-node
        tags:
          karpenter.sh/discovery: ${var.cluster_name}
      EOF
    EOT
  }
}

resource "null_resource" "karpenter_provisioner" {
  depends_on = [null_resource.install_karpenter_crds, null_resource.karpenter_node_template]

  provisioner "local-exec" {
    command = <<-EOT
      kubectl apply -f - <<EOF
      apiVersion: karpenter.sh/v1beta1
      kind: Provisioner
      metadata:
        name: default
        namespace: karpenter
      spec:
        requirements:
          - key: "karpenter.k8s.aws/instance-family"
            operator: In
            values: ["t3", "m5", "c5"]
          - key: "kubernetes.io/arch"
            operator: In
            values: ["amd64", "arm64"]
          - key: "karpenter.sh/capacity-type"
            operator: In
            values: ["spot", "on-demand"]
        providerRef:
          name: default
        limits:
          resources:
            cpu: "1000"
            memory: "1000Gi"
        consolidation:
          enabled: true
        ttlSecondsAfterEmpty: 30
      EOF
    EOT
  }
}