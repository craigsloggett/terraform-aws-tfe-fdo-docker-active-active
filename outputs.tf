output "rds_endpoint" {
  value       = aws_db_instance.tfe.endpoint
  description = "description"
}

output "rds_address" {
  value       = aws_db_instance.tfe.address
  description = "description"
}

output "rds_username" {
  value       = aws_db_instance.tfe.username
  description = "description"
}

output "rds_master_user_secret_arn" {
  value       = aws_db_instance.tfe.master_user_secret[0].secret_arn
  description = "description"
}

output "rds_master_user_secret_value" {
  value       = data.aws_secretsmanager_secret_version.master_user_secret.secret_string
  description = "description"
  sensitive   = true
}

output "postgresql_version" {
  value       = split(".", var.postgresql_version)[0]
  description = "description"
}
