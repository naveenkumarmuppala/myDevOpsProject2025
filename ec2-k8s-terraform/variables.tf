variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "key_name" {
  description = "Existing EC2 key pair name"
  type        = string
  default     = "terra-automate-key"
}

variable "public_key_path" {
  description = "Path to public key"
  type        = string
  default     = "/home/naveen/ec2-terra-key.pub"
}

variable "project_name" {
  description = "Project name"
  type        = string
  default     = "devops-ec2"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.medium"
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
  default     = "vpc-00f06f036ce76276b"
}

variable "ingress_rules" {
  description = "List of ingress rules"
  type = list(object({
    from        = number
    to          = number
    protocol    = string
    cidr_blocks = list(string)
    description = string
  }))
  default = [
    { from = 22, to = 22, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "SSH" },
    { from = 80, to = 80, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "HTTP" },
    { from = 8080, to = 8080, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "Jenkins" },
    { from = 3000, to = 10000, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "K8S1" },
    { from = 30000, to = 32767, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "K8S2" },
    { from = 465, to = 465, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "SMTPS" },
    { from = 25, to = 25, protocol = "tcp", cidr_blocks = ["0.0.0.0/0"], description = "SMTP" }
  ]
}

variable "tags" {
  type = map(string)
  default = {
    Environment = "dev"
    Project     = "Terraform-EC2"
  }
}

variable "subnet_id" {
  description = "Subnet ID"
  type        = string
  default     = "subnet-0b246adb236e01de7"
}

variable "root_volume_size" {
  default = 25
}

variable "root_volume_type" {
  default = "gp3"
}

variable "instance_count" {
  default = 3
}
