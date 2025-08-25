variable "tfe_license" {
  type        = string
  description = "The license for Terraform Enterprise."
}

variable "tfe_version" {
  type        = string
  description = "The version of Terraform Enterprise to deploy."
}

variable "route53_zone_name" {
  type        = string
  description = "The name of the Route53 zone used to host Terraform Enterprise."
}

variable "ec2_bastion_ssh_public_key" {
  type        = string
  description = "The SSH public key used to authenticate to the Bastion EC2 instance."
}
