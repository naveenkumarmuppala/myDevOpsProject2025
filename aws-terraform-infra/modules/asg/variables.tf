variable "name" {
  description = "Name prefix for ASG and related resources"
  type        = string
}

variable "ami_id" {
  description = "AMI ID for EC2 instances in ASG"
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for ASG"
  type        = string
}

variable "key_name" {
  description = "Key pair name for EC2 instances in ASG"
  type        = string
}

variable "ec2_sg" {
  description = "Security group ID for EC2 instances in ASG"
  type        = string
}

variable "private_subnets" {
  description = "List of private subnet IDs for ASG"
  type        = list(string)
}

variable "desired_capacity" {
  description = "Desired number of instances in ASG"
  type        = number
}

variable "min_size" {
  description = "Minimum number of instances in ASG"
  type        = number
}

variable "max_size" {
  description = "Maximum number of instances in ASG"
  type        = number
}

variable "target_group_arn" {
  description = "ARN of the target group for ASG"
  type        = string
}

variable "iam_instance_profile_name" {
  description = "IAM instance profile name for ASG"
  type        = string
}
