variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project name prefix"
  type        = string
  default     = "devsecops"
}

variable "db_engine" {
  description = "Database engine"
  type        = string
  default     = "mysql"
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
  default     = "8.0"
}

variable "db_instance_class" {
  description = "RDS instance type"
  type        = string
  default     = "db.t3.micro" # free tier
}

variable "db_username" {
  description = "Master DB username"
  type        = string
  default     = "admin"
}

variable "db_allocated_storage" {
  description = "Allocated storage (GB)"
  type        = number
  default     = 20
}

variable "db_port" {
  description = "Database port"
  type        = number
  default     = 3306
}

variable "allowed_cidr" {
  description = "CIDR block allowed to access DB"
  type        = string
  default     = "0.0.0.0/0" # ⚠️ open to all, change to your IP for security
}

variable "publicly_accessible" {
  description = "Whether RDS should have a public endpoint"
  type        = bool
  default     = true
}
