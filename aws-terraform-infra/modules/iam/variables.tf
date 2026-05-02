variable "name" {
  description = "Name prefix for IAM and related resources"
  type        = string
}

variable "tags" {
  description = "Common tags for all resources"
  type        = map(string)
  default     = {
    Environment = "dev"
    Project     = "vpc-alb-asg"
  }
}