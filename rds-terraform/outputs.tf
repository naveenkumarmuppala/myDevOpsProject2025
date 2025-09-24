output "db_endpoint" {
  description = "RDS endpoint"
  value       = aws_db_instance.mysql.endpoint
}

output "db_username" {
  description = "Master username"
  value       = aws_db_instance.mysql.username
}

output "db_password_secret" {
  description = "Secrets Manager name where password is stored"
  value       = aws_secretsmanager_secret.db_secret.name
}
