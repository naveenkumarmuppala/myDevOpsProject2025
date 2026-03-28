data "aws_caller_identity" "current" {}

output "aws_account_id" {
  description = "The AWS Account ID Terraform is using"
  value       = data.aws_caller_identity.current.account_id
}

output "aws_caller_arn" {
  description = "The ARN of the IAM principal Terraform is authenticated as"
  value       = data.aws_caller_identity.current.arn
}

output "aws_user_id" {
  description = "The unique identifier of the IAM entity Terraform is using"
  value       = data.aws_caller_identity.current.user_id
}

output "ec2_public_ip" {
  value = aws_instance.devops_ec2.public_ip
}

output "ec2_public_dns" {
  value = aws_instance.devops_ec2.public_dns
}