variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "cluster_name" {
  description = "EKS cluster name"
  type        = string
  default     = "eks-cluster"
}

variable "cluster_version" {
  description = "Kubernetes cluster version"
  type        = string
  default     = "1.29"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "staging"
}