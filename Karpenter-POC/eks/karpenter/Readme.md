Karpenter EKS Deployment
Overview
This Terraform configuration sets up Karpenter in an Amazon EKS cluster with support for both x86 and ARM64 instance types.
Prerequisites

AWS CLI configured
Terraform installed
kubectl installed
EKS cluster already created

Installation

Clone the repository
Navigate to the Karpenter directory
Create a terraform.tfvars file with your cluster details:
hclCopycluster_name = "your-eks-cluster-name"
region       = "us-east-1"

Initialize Terraform:
bashCopyterraform init

Apply the configuration:
bashCopyterraform apply


Using Different Architecture Deployments
x86 Deployment Example
yamlCopyapiVersion: apps/v1
kind: Deployment
metadata:
  name: x86-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: x86-app
  template:
    metadata:
      labels:
        app: x86-app
    spec:
      nodeSelector:
        kubernetes.io/arch: amd64
      containers:
      - name: nginx
        image: nginx
        resources:
          requests:
            cpu: 500m
            memory: 512Mi
ARM64 (Graviton) Deployment Example
yamlCopyapiVersion: apps/v1
kind: Deployment
metadata:
  name: arm-app
spec:
  replicas: 2
  selector:
    matchLabels:
      app: arm-app
  template:
    metadata:
      labels:
        app: arm-app
    spec:
      nodeSelector:
        kubernetes.io/arch: arm64
      containers:
      - name: nginx
        image: nginx
        resources:
          requests:
            cpu: 500m
            memory: 512Mi
Key Features

Supports both on-demand and spot instances
Provisions x86 (Intel/AMD) and ARM64 (Graviton) instances
Automatic scaling based on workload requirements

Cost Optimization
The configuration includes both on-demand and spot instance types to help optimize cluster costs.
Troubleshooting

Verify Karpenter is running:
bashCopykubectl get pods -n karpenter

Check Karpenter logs:
bashCopykubectl logs -n karpenter -l app.kubernetes.io/name=karpenter


Notes

Instances are selected based on workload requirements
Actual instance provisioning depends on cluster resources and Karpenter configuration



kubectl replace --force -f karpenter-controller.yaml --namespace=karpenter
