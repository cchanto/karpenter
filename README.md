# Karpenter EKS Deployment Project
# 📌 Project Overview
This project deploys an EKS Cluster with Karpenter for autoscaling nodes efficiently. The infrastructure is managed using Terraform.



AWS CLI
Terraform (>= 1.0)
kubectl
Helm
AWS account with required IAM permissions
🚀 Deployment Workflow
1️⃣ Deploy Infrastructure
bash
Copy
Edit
cd infra
terraform init
terraform apply -auto-approve
2️⃣ Deploy EKS Cluster
bash
Copy
Edit
cd ../eks
terraform init
terraform apply -auto-approve
3️⃣ Deploy Karpenter


cd karpenter
terraform init
terraform apply -auto-approve
⚙️ Karpenter Configuration
🖥️ Node Templates
File	Description
amd64-provisioner.yaml	Configuration for x86 instances
arm64-provisioner.yaml	Configuration for ARM64 instances
spot-deployment.yaml	Example deployment using spot instances

-🔑 Key Features
-✔️ Support for x86 & ARM64 architectures
-✔️ Spot and on-demand instance types
-✔️ Dynamic node scaling
-✔️ Flexible instance family selection

🔍 Verification Commands
Check Karpenter Pods
bash
Copy
Edit
kubectl get pods -n karpenter
Check Karpenter Logs
bash
Copy
Edit
kubectl logs -n karpenter -l app.kubernetes.io/name=karpenter
Verify Helm Release
bash
Copy
Edit
helm list -n karpenter
🔧 Customization
Modify variables in each module's variables.tf to:

Change instance types
Adjust scaling limits
Configure node selection criteria
🐞 Troubleshooting
Check IAM Roles & Permissions
Ensure that Karpenter IAM Role has the required policies:

bash
Copy
Edit
aws iam list-attached-role-policies --role-name karpenter-controller
Check Network Connectivity
Verify that EKS cluster endpoint is accessible:

bash
Copy
Edit
kubectl cluster-info
🔥 Cleanup
To destroy the resources, run the commands in reverse order:

bash
Copy
Edit
# Destroy Karpenter
cd karpenter
terraform destroy -auto-approve

# Destroy EKS Cluster
cd ../eks
terraform destroy -auto-approve

# Destroy Infrastructure
cd ../infra
terraform destroy -auto-approve
📝 Notes
Ensure AWS credentials are configured correctly.
Modify variables according to your environment.
Review and adjust security groups and IAM roles as needed.
💡 Contributions
Contributions are welcome! Please open an issue or submit a pull request for improvements.

📖 Additional Resources
AWS Graviton Processor Docs
Karpenter Official Docs
Terraform AWS EKS Module
This README.md follows the best GitHub formatting standards for documentation. 🎯🚀
