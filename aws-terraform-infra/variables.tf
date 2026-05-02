variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "ami_name_filter" {
  description = "AMI name filter for Amazon Linux 2"
  type        = string
  default     = "amzn2-ami-hvm-*-x86_64-gp2"
}