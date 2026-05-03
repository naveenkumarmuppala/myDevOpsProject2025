variable "environment" {
  description = "Deployment environment (e.g., dev, stage, prod)"
  type        = string
}

variable "project" {
  description = "Project name for tagging"
  type        = string
  default     = "vpc-alb-asg"
}

variable "account_id" {
  description = "AWS Account ID for naming resources"
  type        = string
}
