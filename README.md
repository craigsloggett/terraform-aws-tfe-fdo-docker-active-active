# tfe-infrastructure
Infrastructure as Code Repository to Standup TFE

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | ~> 1.1 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | 5.51.1 |
| <a name="requirement_http"></a> [http](#requirement\_http) | 3.4.2 |
| <a name="requirement_random"></a> [random](#requirement\_random) | 3.6.2 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.51.1 |
| <a name="provider_http"></a> [http](#provider\_http) | 3.4.2 |
| <a name="provider_random"></a> [random](#provider\_random) | 3.6.2 |

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
| [aws_db_instance.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/db_instance) | resource |
| [aws_db_parameter_group.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/db_parameter_group) | resource |
| [aws_db_subnet_group.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/db_subnet_group) | resource |
| [aws_iam_instance_profile.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/iam_instance_profile) | resource |
| [aws_iam_policy.ec2_modify_metadata](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/iam_policy) | resource |
| [aws_iam_policy.tfe_s3](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/iam_policy) | resource |
| [aws_iam_policy.tfe_secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/iam_policy) | resource |
| [aws_iam_policy.tfe_ssm](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/iam_policy) | resource |
| [aws_iam_role.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ec2_modify_metadata](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.tfe_s3](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.tfe_secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.tfe_ssm](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/iam_role_policy_attachment) | resource |
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
| [aws_security_group.rds](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/security_group) | resource |
| [aws_security_group.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/security_group) | resource |
| [aws_ssm_parameter.postgresql_major_version](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.rds_fqdn](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.s3_bucket_id](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.s3_region](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.tfe_db_name](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.tfe_db_password](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.tfe_db_username](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.tfe_encryption_password](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.tfe_fqdn](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.tfe_license](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/ssm_parameter) | resource |
| [aws_ssm_parameter.tfe_version](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/ssm_parameter) | resource |
| [aws_vpc_endpoint.s3](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_endpoint) | resource |
| [aws_vpc_endpoint_route_table_association.private](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_endpoint_route_table_association.public](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_endpoint_route_table_association) | resource |
| [aws_vpc_security_group_egress_rule.alb](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.bastion](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.rds](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_egress_rule.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_egress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.alb](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.bastion_ssh](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.rds](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.tfe_https](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_ingress_rule) | resource |
| [aws_vpc_security_group_ingress_rule.tfe_ssh](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/resources/vpc_security_group_ingress_rule) | resource |
| [random_string.tfe_db_password](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/string) | resource |
| [random_string.tfe_encryption_password](https://registry.terraform.io/providers/hashicorp/random/3.6.2/docs/resources/string) | resource |
| [aws_ami.debian](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/ami) | data source |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.ec2_modify_metadata](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tfe_assume_role](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tfe_s3](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tfe_secrets_manager](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.tfe_ssm](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/iam_policy_document) | data source |
| [aws_kms_key.ebs](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/kms_key) | data source |
| [aws_kms_key.secretsmanager](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/kms_key) | data source |
| [aws_kms_key.ssm](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/kms_key) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/region) | data source |
| [aws_route53_zone.tfe](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/route53_zone) | data source |
| [aws_secretsmanager_secret_version.master_user_secret](https://registry.terraform.io/providers/hashicorp/aws/5.51.1/docs/data-sources/secretsmanager_secret_version) | data source |
| [http_http.myip](https://registry.terraform.io/providers/hashicorp/http/3.4.2/docs/data-sources/http) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_alb_security_group_name"></a> [alb\_security\_group\_name](#input\_alb\_security\_group\_name) | The name of the Application Load Balancer Security Group. | `string` | `"alb-sg"` | no |
| <a name="input_bastion_security_group_name"></a> [bastion\_security\_group\_name](#input\_bastion\_security\_group\_name) | The name of the Bastion Host Security Group. | `string` | `"bastion-sg"` | no |
| <a name="input_ec2_iam_role_name"></a> [ec2\_iam\_role\_name](#input\_ec2\_iam\_role\_name) | The name of the IAM Role assigned to the EC2 Instance Profile assigned to the TFE hosts. | `string` | `"tfe-iam-role"` | no |
| <a name="input_ec2_instance_profile_name"></a> [ec2\_instance\_profile\_name](#input\_ec2\_instance\_profile\_name) | The name of the EC2 Instance Profile assigned to the TFE hosts. | `string` | `"tfe-instance-profile"` | no |
| <a name="input_lb_name"></a> [lb\_name](#input\_lb\_name) | The name of the application load balancer used to distribute HTTPS traffic across TFE hosts. | `string` | `"tfe-web-alb"` | no |
| <a name="input_lb_target_group_name"></a> [lb\_target\_group\_name](#input\_lb\_target\_group\_name) | The name of the target group used to direct HTTPS traffic to TFE hosts. | `string` | `"tfe-web-alb-tg"` | no |
| <a name="input_postgresql_version"></a> [postgresql\_version](#input\_postgresql\_version) | The version of the PostgreSQL engine to deploy. | `string` | `"15.7"` | no |
| <a name="input_rds_instance_class"></a> [rds\_instance\_class](#input\_rds\_instance\_class) | The instance type (size) of the RDS instance. | `string` | `"db.t3.medium"` | no |
| <a name="input_rds_instance_master_username"></a> [rds\_instance\_master\_username](#input\_rds\_instance\_master\_username) | The username of the RDS master user. | `string` | `"tfe"` | no |
| <a name="input_rds_instance_name"></a> [rds\_instance\_name](#input\_rds\_instance\_name) | The name of the RDS instance used to externalize TFE services. | `string` | `"tfe-postgres-db"` | no |
| <a name="input_rds_parameter_group_name"></a> [rds\_parameter\_group\_name](#input\_rds\_parameter\_group\_name) | The name of the RDS Parameter Group. | `string` | `"rds-pg"` | no |
| <a name="input_rds_security_group_name"></a> [rds\_security\_group\_name](#input\_rds\_security\_group\_name) | The name of the RDS Security Group. | `string` | `"rds-sg"` | no |
| <a name="input_route53_zone_name"></a> [route53\_zone\_name](#input\_route53\_zone\_name) | The name of the Route53 Zone used to host TFE. | `string` | `"craig-sloggett.sbx.hashidemos.io"` | no |
| <a name="input_s3_vpc_endpoint_name"></a> [s3\_vpc\_endpoint\_name](#input\_s3\_vpc\_endpoint\_name) | The name of the S3 VPC Endpoint. | `string` | `"tfe-vpce-s3"` | no |
| <a name="input_tfe_db_name"></a> [tfe\_db\_name](#input\_tfe\_db\_name) | The name of the database used to store TFE data in. | `string` | `"tfe"` | no |
| <a name="input_tfe_db_username"></a> [tfe\_db\_username](#input\_tfe\_db\_username) | The username used to access the TFE database. | `string` | `"tfe_user"` | no |
| <a name="input_tfe_hostname"></a> [tfe\_hostname](#input\_tfe\_hostname) | The hostname of Terraform Enterprise instance. | `string` | `"tfe"` | no |
| <a name="input_tfe_license"></a> [tfe\_license](#input\_tfe\_license) | The license for Terraform Enterprise. | `string` | n/a | yes |
| <a name="input_tfe_security_group_name"></a> [tfe\_security\_group\_name](#input\_tfe\_security\_group\_name) | The name of the TFE Hosts Security Group. | `string` | `"tfe-sg"` | no |
| <a name="input_tfe_version"></a> [tfe\_version](#input\_tfe\_version) | The version of Terraform Enterprise to deploy. | `string` | `"v202401-2"` | no |
| <a name="input_vpc_name"></a> [vpc\_name](#input\_vpc\_name) | The name of the VPC used to host TFE. | `string` | `"tfe-vpc"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_postgresql_version"></a> [postgresql\_version](#output\_postgresql\_version) | description |
| <a name="output_rds_address"></a> [rds\_address](#output\_rds\_address) | description |
| <a name="output_rds_endpoint"></a> [rds\_endpoint](#output\_rds\_endpoint) | description |
| <a name="output_rds_master_user_secret_arn"></a> [rds\_master\_user\_secret\_arn](#output\_rds\_master\_user\_secret\_arn) | description |
| <a name="output_rds_master_user_secret_value"></a> [rds\_master\_user\_secret\_value](#output\_rds\_master\_user\_secret\_value) | description |
| <a name="output_rds_username"></a> [rds\_username](#output\_rds\_username) | description |
<!-- END_TF_DOCS -->
