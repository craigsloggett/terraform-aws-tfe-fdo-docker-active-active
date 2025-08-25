module "tfe" {
  source = "../"

  # Required
  tfe_license                = var.tfe_license
  route53_zone_name          = var.route53_zone_name
  ec2_bastion_ssh_public_key = var.ec2_bastion_ssh_public_key

  # Optional
  tfe_version = var.tfe_version
}

