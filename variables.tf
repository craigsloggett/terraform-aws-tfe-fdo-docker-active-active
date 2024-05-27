variable "vpc_name" {
  type        = string
  description = "VPC"
  default     = "tfe-vpc"
}

variable "s3_vpc_endpoint_name" {
  type        = string
  description = "S3 VPC Endpoint"
  default     = "tfe-vpce-s3"
}

variable "bastion_security_group_name" {
  type        = string
  description = "Security Group"
  default     = "bastion-sg"
}

variable "tfe_security_group_name" {
  type        = string
  description = "Security Group"
  default     = "tfe-sg"
}

variable "alb_security_group_name" {
  type        = string
  description = "Security Group"
  default     = "alb-sg"
}

variable "route53_zone_name" {
  type        = string
  description = "Route53 Zone"
  default     = "craig-sloggett.sbx.hashidemos.io"
}

variable "ec2_iam_role_name" {
  type        = string
  description = "EC2 IAM Role"
  default     = "tfe-iam-role"
}

variable "ec2_instance_profile_name" {
  type        = string
  description = "EC2 Instance Profile"
  default     = "tfe-instance-profile"
}

variable "lb_name" {
  type        = string
  description = "Load Balancer"
  default     = "tfe-web-alb"
}

variable "lb_target_group_name" {
  type        = string
  description = "Load Balancer Target Group"
  default     = "tfe-web-alb-tg"
}

variable "tfe_version" {
  type        = string
  description = "The version of Terraform Enterprise to deploy."
  default     = "v202401-2"
}

variable "tfe_hostname" {
  type        = string
  description = "The hostname of Terraform Enterprise instance."
  default     = "tfe.craig-sloggett.sbx.hashidemos.io"
}
