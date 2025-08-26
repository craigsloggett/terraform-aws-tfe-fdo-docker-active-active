# Simple TFE Deployment

This example demonstrates a minimal configuration for deploying Terraform 
Enterprise (TFE) on AWS using this module. It provisions supporting 
infrastructure such as DNS records, a bastion host, and EC2 instances, and 
outputs the fully qualified domain name (FQDN) of the TFE endpoint. Most
inputs are omitted in favour of using defaults.

## Usage

```hcl
module "tfe" {
  source = "../"

  tfe_license                = var.tfe_license
  tfe_version                = var.tfe_version
  route53_zone_name          = var.route53_zone_name
  ec2_bastion_ssh_public_key = var.ec2_bastion_ssh_public_key
  ec2_instance_ami_name      = var.ec2_instance_ami_name
}
```

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 6.10.0 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.5.0 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.7.2 |

## Providers

No providers.

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_tfe"></a> [tfe](#module\_tfe) | ../ | n/a |

## Resources

No resources.

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_ec2_bastion_ssh_public_key"></a> [ec2\_bastion\_ssh\_public\_key](#input\_ec2\_bastion\_ssh\_public\_key) | The SSH public key used to authenticate to the Bastion EC2 instance. | `string` | n/a | yes |
| <a name="input_ec2_instance_ami_name"></a> [ec2\_instance\_ami\_name](#input\_ec2\_instance\_ami\_name) | The name of the AMI used as a filter for both bastion and TFE EC2 instances. | `string` | `"debian-12-amd64-20250814-2204"` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | The name of the Route53 zone used to host Terraform Enterprise. | `string` | n/a | yes |
| <a name="input_tfe_license"></a> [tfe\_license](#input\_tfe\_license) | The license for Terraform Enterprise. | `string` | n/a | yes |
| <a name="input_tfe_version"></a> [tfe\_version](#input\_tfe\_version) | The version of Terraform Enterprise to deploy. | `string` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_tfe_hostname"></a> [tfe\_hostname](#output\_tfe\_hostname) | Fully qualified domain name (FQDN) of the Terraform Enterprise endpoint. |
<!-- END_TF_DOCS -->
