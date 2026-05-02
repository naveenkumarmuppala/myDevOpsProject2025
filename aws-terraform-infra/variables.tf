variable "region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "public_subnets" {
  description = "Public subnet CIDRs"
  type        = list(string)
}

variable "private_subnets" {
  description = "Private subnet CIDRs"
  type        = list(string)
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
}

variable "ami" {
  description = "AMI ID for EC2"
  type        = string
}

variable "user_data" {
  description = "User data script"
  type        = string
}

variable "ec2_sg" {
  description = "Security group ID for EC2"
  type        = string
}

variable "ami_name_filter" {
  default = "amzn2-ami-hvm-*-x86_64-gp2"
}

variable "tags" {
  description = "Common tags"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "vpc-alb-asg"
  }
}