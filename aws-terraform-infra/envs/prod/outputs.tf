output "vpc_id" {
  description = "VPC ID"
  value       = module.vpc.vpc_id
}

output "public_subnet_ids" {
  description = "Public subnet IDs"
  value       = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  description = "Private subnet IDs"
  value       = module.vpc.private_subnet_ids
}

output "alb_dns_name" {
  description = "ALB DNS name (use this to access application)"
  value       = module.alb.alb_dns_name
}

output "target_group_arn" {
  description = "ALB Target Group ARN"
  value       = module.alb.target_group_arn
}

output "asg_name" {
  description = "Auto Scaling Group name"
  value       = module.asg.asg_name
}

output "launch_template_id" {
  description = "Launch Template ID"
  value       = module.asg.launch_template_id
}

output "alb_security_group_id" {
  description = "ALB Security Group ID"
  value       = module.security.alb_sg_id
}

output "ec2_security_group_id" {
  description = "EC2 Security Group ID"
  value       = module.security.ec2_sg_id
}

output "instance_profile_name" {
  description = "IAM Instance Profile name for ASG"
  value       = module.iam.instance_profile_name
}

output "bastion_instance_id" {
  description = "ID of the bastion host EC2 instance"
  value       = module.bastion.bastion_instance_id
}

output "bastion_public_ip" {
  description = "Public IP address of the bastion host"
  value       = module.bastion.bastion_public_ip
}

output "bastion_sg_id" {
  description = "ID of the bastion host security group"
  value       = module.bastion.bastion_sg_id
}
