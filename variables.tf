variable "tfe_version" {
  type        = string
  description = "The version of Terraform Enterprise to deploy."
  default     = "v202401-2"
}

variable "postgresql_version" {
  type        = string
  description = "The version of the PostgreSQL engine to deploy."
  default     = "16.3"
}

variable "tfe_hostname" {
  type        = string
  description = "The hostname of Terraform Enterprise instance."
  default     = "tfe"
}

variable "vpc_name" {
  type        = string
  description = "The name of the VPC used to host TFE."
  default     = "tfe-vpc"
}

variable "s3_vpc_endpoint_name" {
  type        = string
  description = "The name of the S3 VPC Endpoint."
  default     = "tfe-vpce-s3"
}

variable "bastion_security_group_name" {
  type        = string
  description = "The name of the Bastion Host Security Group."
  default     = "bastion-sg"
}

variable "tfe_security_group_name" {
  type        = string
  description = "The name of the TFE Hosts Security Group."
  default     = "tfe-sg"
}

variable "alb_security_group_name" {
  type        = string
  description = "The name of the Application Load Balancer Security Group."
  default     = "alb-sg"
}

variable "rds_security_group_name" {
  type        = string
  description = "The name of the RDS Security Group."
  default     = "rds-sg"
}

variable "route53_zone_name" {
  type        = string
  description = "The name of the Route53 Zone used to host TFE."
  default     = "craig-sloggett.sbx.hashidemos.io"
}

variable "ec2_iam_role_name" {
  type        = string
  description = "The name of the IAM Role assigned to the EC2 Instance Profile assigned to the TFE hosts."
  default     = "tfe-iam-role"
}

variable "ec2_instance_profile_name" {
  type        = string
  description = "The name of the EC2 Instance Profile assigned to the TFE hosts."
  default     = "tfe-instance-profile"
}

variable "lb_name" {
  type        = string
  description = "The name of the application load balancer used to distribute HTTPS traffic across TFE hosts."
  default     = "tfe-web-alb"
}

variable "lb_target_group_name" {
  type        = string
  description = "The name of the target group used to direct HTTPS traffic to TFE hosts."
  default     = "tfe-web-alb-tg"
}

variable "rds_instance_name" {
  type        = string
  description = "The name of the RDS instance used to externalize TFE services."
  default     = "tfe-postgres-db"
}

variable "rds_instance_db_name" {
  type        = string
  description = "The name of the database to create to store TFE data in."
  default     = "tfe"
}

variable "rds_instance_master_username" {
  type        = string
  description = "The username of the RDS master user."
  default     = "tfe"
}

variable "rds_instance_username" {
  type        = string
  description = "The username of the RDS TFE user."
  default     = "tfe_user"
}

variable "rds_instance_class" {
  type        = string
  description = "The instance type (size) of the RDS instance."
  default     = "db.t3.medium"
}
