variable "name" {
    description = "The name prefix for the ALB and its resources"
    type        = string
}

variable "vpc_id" {
    description = "The ID of the VPC where the ALB will be created"
    type        = string
}

variable "public_subnets" {
    description = "A list of public subnet IDs for the ALB"
    type        = list(string)
}

variable "alb_sg" {
    description = "The security group ID for the ALB"
    type        = string
}

variable "tags" {
    description = "A map of tags to assign to the ALB and its resources"
    type        = map(string)
    default     = {
    Environment = "dev"
    Project     = "vpc-alb-asg"
  }
}