output "tfe_hostname" {
  description = "Fully qualified domain name (FQDN) of the Terraform Enterprise endpoint."
  value       = module.tfe.tfe_hostname
}
