resource "aws_ssm_parameter" "tfe_license" {
  name        = "/TFE/License"
  description = "Terraform Enterprise License"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = var.tfe_license
}

resource "aws_ssm_parameter" "tfe_version" {
  name        = "/TFE/Version"
  description = "Terraform Enterprise Version"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = var.tfe_version
}

resource "random_string" "tfe_encryption_password" {
  length = 32
}

resource "aws_ssm_parameter" "tfe_encryption_password" {
  name        = "/TFE/Encryption-Password"
  description = "Terraform Enterprise Encryption Password"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = random_string.tfe_encryption_password.result
}

resource "aws_ssm_parameter" "tfe_fqdn" {
  name        = "/TFE/TFE-FQDN"
  description = "TFE Instance FQDN"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = local.route53_alias_record_name
}

resource "aws_ssm_parameter" "tfe_db_name" {
  name        = "/TFE/DB-Name"
  description = "Terraform Enterprise Database Name"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = var.tfe_db_name
}

resource "aws_ssm_parameter" "tfe_db_username" {
  name        = "/TFE/DB-Username"
  description = "Terraform Enterprise Database Username"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = var.tfe_db_username
}

resource "random_string" "tfe_db_password" {
  length = 32
}

resource "aws_ssm_parameter" "tfe_db_password" {
  name        = "/TFE/DB-Password"
  description = "Terraform Enterprise Database Password"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = random_string.tfe_db_password.result
}

resource "aws_ssm_parameter" "postgresql_major_version" {
  name        = "/TFE/PostgreSQL-Major-Version"
  description = "PostgreSQL Major Version"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = split(".", var.postgresql_version)[0] # The install script only needs the major version number.
}

resource "aws_ssm_parameter" "rds_fqdn" {
  name        = "/TFE/RDS-FQDN"
  description = "RDS Instance FQDN"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = aws_db_instance.tfe.address
}

resource "aws_ssm_parameter" "s3_region" {
  name        = "/TFE/S3-Region"
  description = "S3 Region"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = data.aws_region.current.name
}

resource "aws_ssm_parameter" "s3_bucket_id" {
  name        = "/TFE/S3-Bucket-ID"
  description = "S3 Bucket ID"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = aws_s3_bucket.tfe.id
}
