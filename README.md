# tfe-infrastructure
Infrastructure as Code Repository to Standup TFE

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.51.1 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.4.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.51.1 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.4.2 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_vpc"></a> [vpc](#module\_vpc) | terraform-aws-modules/vpc/aws | 5.8.1 |

## Resources

| Name | Type |
|------|------|
| [aws_acm_certificate.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/acm_certificate) | resource |
| [aws_acm_certificate_validation.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/acm_certificate_validation) | resource |
| [aws_autoscaling_group.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/autoscaling_group) | resource |
| [aws_iam_instance_profile.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/iam_role) | resource |
| [aws_instance.bastion](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/instance) | resource |
| [aws_key_pair.self](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/key_pair) | resource |
| [aws_launch_template.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/launch_template) | resource |
| [aws_lb.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/lb) | resource |
| [aws_lb_listener.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/lb_listener) | resource |
| [aws_lb_target_group.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/lb_target_group) | resource |
| [aws_route53_record.alias_record](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/route53_record) | resource |
| [aws_route53_record.cert_validation_record](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/route53_record) | resource |
| [aws_s3_bucket.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_public_access_block.tfe_public_access_block](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.tfe_sse](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.tfe_versioning](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/s3_bucket_versioning) | resource |
| [aws_security_group.alb](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/security_group) | resource |
| [aws_security_group.bastion](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/security_group) | resource |
| [aws_security_group.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/security_group) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_security_group_egress_rule.alb](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.bastion](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.alb](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.bastion_ssh](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.tfe_https](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.tfe_ssh](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_ami.debian](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.tfe_assume_role](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/iam_policy_document) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/region) | data source |
| [aws_route53_zone.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/route53_zone) | data source |
| [aws_secretsmanager_secret.tfe_encryption_password](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret.tfe_license](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/secretsmanager_secret) | data source |
| [aws_secretsmanager_secret_version.encryption_password](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/secretsmanager_secret_version) | data source |
| [aws_secretsmanager_secret_version.tfe_license](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/secretsmanager_secret_version) | data source |
| [http_http.myip](https://registry.terraform.io/providers/hashicorp/http/3.4.2/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_security_group_name"></a> [alb\_security\_group\_name](#input\_alb\_security\_group\_name) | Security Group | `string` | `"alb-sg"` | no |
| <a name="input_bastion_security_group_name"></a> [bastion\_security\_group\_name](#input\_bastion\_security\_group\_name) | Security Group | `string` | `"bastion-sg"` | no |
| <a name="input_ec2_iam_role_name"></a> [ec2\_iam\_role\_name](#input\_ec2\_iam\_role\_name) | EC2 IAM Role | `string` | `"tfe-iam-role"` | no |
| <a name="input_ec2_instance_profile_name"></a> [ec2\_instance\_profile\_name](#input\_ec2\_instance\_profile\_name) | EC2 Instance Profile | `string` | `"tfe-instance-profile"` | no |
| <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name) | Load Balancer | `string` | `"tfe-web-alb"` | no |
| <a name="input_lb_target_group_name"></a> [lb\_target\_group\_name](#input\_lb\_target\_group\_name) | Load Balancer Target Group | `string` | `"tfe-web-alb-tg"` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | Route53 Zone | `string` | `"craig-sloggett.sbx.hashidemos.io"` | no |
| <a name="input_s3_vpc_endpoint_name"></a> [s3\_vpc\_endpoint\_name](#input\_s3\_vpc\_endpoint\_name) | S3 VPC Endpoint | `string` | `"tfe-vpce-s3"` | no |
| <a name="input_tfe_hostname"></a> [tfe\_hostname](#input\_tfe\_hostname) | The hostname of Terraform Enterprise instance. | `string` | `"tfe"` | no |
| <a name="input_tfe_security_group_name"></a> [tfe\_security\_group\_name](#input\_tfe\_security\_group\_name) | Security Group | `string` | `"tfe-sg"` | no |
| <a name="input_tfe_version"></a> [tfe\_version](#input\_tfe\_version) | The version of Terraform Enterprise to deploy. | `string` | `"v202401-2"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | VPC | `string` | `"tfe-vpc"` | no |

## Outputs

No outputs.
<!-- END_TF_DOCS -->
