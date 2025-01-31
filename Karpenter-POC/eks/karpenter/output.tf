output "karpenter_controller_role_arn" {
  description = "ARN of IAM role for Karpenter controller"
  value       = aws_iam_role.karpenter_controller.arn
}

output "karpenter_instance_profile_name" {
  description = "Name of Karpenter instance profile"
  value       = aws_iam_instance_profile.karpenter.name
}