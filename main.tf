data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "tfe" {
  name = var.route53_zone_name
}

data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

data "aws_ami" "debian" {
  most_recent = true
  owners      = ["136693071363"]

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
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

data "aws_secretsmanager_secret_version" "master_user_secret" {
  secret_id = aws_db_instance.tfe.master_user_secret[0].secret_arn
}

data "aws_kms_key" "secretsmanager" {
  key_id = "alias/aws/secretsmanager"
}

data "aws_kms_key" "ssm" {
  key_id = "alias/aws/ssm"
}

locals {
  account_id                = data.aws_caller_identity.current.account_id
  region                    = data.aws_region.current.name
  bucket_name               = "${local.account_id}-${local.region}-terraform-enterprise"
  my_ip                     = chomp(data.http.myip.response_body)
  route53_alias_record_name = "${var.tfe_hostname}.${var.route53_zone_name}"
}
