module "tfe" {
  source = "../"

  # Required
  tfe_license                = var.tfe_license
  tfe_version                = var.tfe_version
  route53_zone_name          = var.route53_zone_name
  ec2_bastion_ssh_public_key = var.ec2_bastion_ssh_public_key
  ec2_bastion_allowed_ips    = var.ec2_bastion_allowed_ips
  ec2_instance_ami_name      = var.ec2_instance_ami_name
  postgresql_version         = var.postgresql_version
}
