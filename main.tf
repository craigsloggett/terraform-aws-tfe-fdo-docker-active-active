data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_route53_zone" "tfe" {
  name = var.route53_zone_name
}

data "aws_ami" "debian" {
  count       = var.ec2_instance_ami_name == "debian-13-amd64-20251117-2299" ? 1 : 0
  most_recent = true
  owners      = ["136693071363"]

  filter {
    name   = "name"
    values = [var.ec2_instance_ami_name]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

data "aws_ami" "hc-base-ami" {
  count = var.ec2_instance_ami_name != "debian-13-amd64-20251117-2299" ? 1 : 0
  filter {
    name   = "name"
    values = ["${var.ec2_instance_ami_name}-*"]
  }
  filter {
    name   = "state"
    values = ["available"]
  }
  most_recent = true
  owners      = ["888995627335"]
}

data "aws_kms_key" "rds" {
  key_id = "alias/aws/rds"
}

data "aws_kms_key" "secretsmanager" {
  key_id = "alias/aws/secretsmanager"
}

data "aws_kms_key" "ssm" {
  key_id = "alias/aws/ssm"
}

locals {
  account_id                = data.aws_caller_identity.current.account_id
  region                    = data.aws_region.current.region
  bucket_name               = "${local.account_id}-${local.region}-terraform-enterprise"
  route53_alias_record_name = "${var.tfe_subdomain}.${var.route53_zone_name}"
  ami_id                    = var.ec2_instance_ami_name == "debian-13-amd64-20251117-2299" ? data.aws_ami.debian[0].id : data.aws_ami.hc-base-ami[0].id
  ami_architecture          = strcontains(var.ec2_instance_ami_name, "arm64") ? "arm64" : "x86_64"
  tfe_instance_type         = coalesce(var.ec2_tfe_instance_type, local.ami_architecture == "arm64" ? "t4g.medium" : "t3.medium")

  user_data_script = {
    "debian-13-amd64-20251117-2299" = "${path.module}/scripts/tfe-host-debian-user-data.sh"
    "hc-base-ubuntu-2204"           = "${path.module}/scripts/tfe-host-ubuntu-2204-user-data.sh"
    "hc-base-ubuntu-2404-amd64"     = "${path.module}/scripts/tfe-host-ubuntu-2404-user-data.sh"
    "hc-base-ubuntu-2404-arm64"     = "${path.module}/scripts/tfe-host-ubuntu-2404-user-data.sh"
    "hc-base-al2023-x86_64"         = "${path.module}/scripts/tfe-host-al2023-user-data.sh"
    "hc-base-al2023-arm64"          = "${path.module}/scripts/tfe-host-al2023-user-data.sh"
    "hc-base-rhel-9-x86_64"         = "${path.module}/scripts/tfe-host-rhel-9-user-data.sh"
    "hc-base-rhel-9-arm64"          = "${path.module}/scripts/tfe-host-rhel-9-user-data.sh"
  }[var.ec2_instance_ami_name]
}

resource "random_string" "tfe_encryption_password" {
  length = 256
}

resource "random_string" "tfe_database_password" {
  length = 64
}

resource "random_string" "tfe_redis_password" {
  length  = 128
  special = false # The Redis auth token doesn't accept special characters.
}
