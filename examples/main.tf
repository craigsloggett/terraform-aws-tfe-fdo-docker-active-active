module "tfe" {
  source = "../"

  # Required
  tfe_license                = var.tfe_license
  tfe_version                = var.tfe_version
  route53_zone_name          = var.route53_zone_name
  ec2_bastion_ssh_public_key = var.ec2_bastion_ssh_public_key
}
