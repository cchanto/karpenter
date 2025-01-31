# # 2-eks/security_groups.tf
# resource "aws_security_group" "worker_group_mgmt" {
#   name_prefix = "${var.cluster_name}-worker_group_mgmt"
#   vpc_id      = module.vpc.vpc_id  # Direct reference to VPC module output

#   ingress {
#     from_port = 22
#     to_port   = 22
#     protocol  = "tcp"
#     cidr_blocks = [
#       "10.0.0.0/8",
#       "172.16.0.0/12",
#       "192.168.0.0/16",
#     ]
#   }

#   egress {
#     from_port   = 0
#     to_port     = 0
#     protocol    = "-1"
#     cidr_blocks = ["0.0.0.0/0"]
#   }

#   tags = {
#     Name        = "${var.cluster_name}-worker-sg"
#     Environment = var.environment
#   }
# }

