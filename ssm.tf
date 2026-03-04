resource "aws_ssm_parameter" "tfe_version" {
  name        = "/TFE/TFE_VERSION"
  description = "Terraform Enterprise Version"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = var.tfe_version
}

resource "aws_ssm_parameter" "postgresql_major_version" {
  name        = "/TFE/POSTGRESQL_MAJOR_VERSION"
  description = "PostgreSQL Major Version"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = split(".", var.postgresql_version)[0] # The install script only needs the major version number.
}

# The Admin Token URL is populated by the Terraform Enterprise application on startup.
resource "aws_ssm_parameter" "tfe_admin_token_url" {
  name        = "/TFE/TFE_ADMIN_TOKEN_URL"
  description = "Terraform Enterprise Admin Token URL"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = "PLACEHOLDER"

  lifecycle { ignore_changes = [value] }
}

# Application Settings

resource "aws_ssm_parameter" "tfe_encryption_password" {
  name        = "/TFE/TFE_ENCRYPTION_PASSWORD"
  description = "Terraform Enterprise Encryption Password"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = random_string.tfe_encryption_password.result
}

resource "aws_ssm_parameter" "tfe_hostname" {
  name        = "/TFE/TFE_HOSTNAME"
  description = "Terraform Enterprise Hostname"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = local.route53_alias_record_name
}

resource "aws_ssm_parameter" "tfe_license" {
  name        = "/TFE/TFE_LICENSE"
  description = "Terraform Enterprise License"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = var.tfe_license
}

# Database Settings

resource "aws_ssm_parameter" "tfe_database_host" {
  name        = "/TFE/TFE_DATABASE_HOST"
  description = "Terraform Enterprise Database Hostname"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = aws_db_instance.tfe.address
}

resource "aws_ssm_parameter" "tfe_database_name" {
  name        = "/TFE/TFE_DATABASE_NAME"
  description = "Terraform Enterprise Database Name"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = var.tfe_database_name
}

resource "aws_ssm_parameter" "tfe_database_user" {
  name        = "/TFE/TFE_DATABASE_USER"
  description = "Terraform Enterprise Database User"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = var.tfe_database_user
}

resource "aws_ssm_parameter" "tfe_database_password" {
  name        = "/TFE/TFE_DATABASE_PASSWORD"
  description = "Terraform Enterprise Database Password"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = random_string.tfe_database_password.result
}

# Redis Settings

resource "aws_ssm_parameter" "tfe_redis_host" {
  name        = "/TFE/TFE_REDIS_HOST"
  description = "Terraform Enterprise Redis Host"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = aws_elasticache_replication_group.tfe.primary_endpoint_address
}

resource "aws_ssm_parameter" "tfe_redis_password" {
  name        = "/TFE/TFE_REDIS_PASSWORD"
  description = "Terraform Enterprise Redis Password"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = random_string.tfe_redis_password.result
}

# Object Storage Settings

resource "aws_ssm_parameter" "tfe_object_storage_s3_region" {
  name        = "/TFE/TFE_OBJECT_STORAGE_S3_REGION"
  description = "Terraform Enterprise Object Storage S3 Region"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = data.aws_region.current.region
}

resource "aws_ssm_parameter" "tfe_object_storage_s3_bucket" {
  name        = "/TFE/TFE_OBJECT_STORAGE_S3_BUCKET"
  description = "Terraform Enterprise Object Storage S3 Bucket"
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = aws_s3_bucket.tfe.id
}

# Uptycs EDR Agent Settings (Debian instances only)

resource "aws_ssm_parameter" "uptycs_sensor_url" {
  count       = var.ec2_instance_ami_name == "debian-13-amd64-20251117-2299" ? 1 : 0
  name        = "/TFE/UPTYCS_SENSOR_URL"
  description = "S3 URI (s3://bucket/key) for the Uptycs EDR sensor .deb package."
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = var.uptycs_sensor_url

  lifecycle {
    precondition {
      condition     = var.uptycs_sensor_url != null
      error_message = "uptycs_sensor_url must be set when ec2_instance_ami_name is the Debian AMI."
    }
  }
}

resource "aws_ssm_parameter" "uptycs_owner_tag" {
  count       = var.ec2_instance_ami_name == "debian-13-amd64-20251117-2299" ? 1 : 0
  name        = "/TFE/UPTYCS_OWNER_TAG"
  description = "Uptycs osquery OWNER tag value (e.g. team/owner@hashicorp.com)."
  type        = "SecureString"
  key_id      = data.aws_kms_key.ssm.id
  value       = var.uptycs_owner_tag

  lifecycle {
    precondition {
      condition     = var.uptycs_owner_tag != null
      error_message = "uptycs_owner_tag must be set when ec2_instance_ami_name is the Debian AMI."
    }
  }
}

# SSM Agent Auto-Update Association
#
# Runs AWS-UpdateSSMAgent on all instances tagged ManagedBy=terraform at
# registration time and weekly thereafter, ensuring the SSM agent is always
# up to date without requiring user-data changes or AMI rebakes.

resource "aws_ssm_association" "update_ssm_agent" {
  name                        = "AWS-UpdateSSMAgent"
  association_name            = "update-ssm-agent"
  apply_only_at_cron_interval = false # Also runs immediately when instance registers

  schedule_expression = "rate(7 days)"

  targets {
    key    = "tag:ManagedBy"
    values = ["terraform"]
  }
}
