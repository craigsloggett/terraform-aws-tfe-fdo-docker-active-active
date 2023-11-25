data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

data "aws_route53_zone" "tfe" {
  name = "craig-sloggett.sbx.hashidemos.io"
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

data "aws_secretsmanager_secret" "tfe_license" {
  name = "tfe/license"
}

data "aws_secretsmanager_secret" "tfe_encryption_password" {
  name = "tfe/encryption_password"
}
