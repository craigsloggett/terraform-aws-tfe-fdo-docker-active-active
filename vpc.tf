module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.7.0"

  name = var.vpc_name
  cidr = "10.0.0.0/16"

  azs             = ["ca-central-1a", "ca-central-1b", "ca-central-1d"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  single_nat_gateway = true

  default_network_acl_egress = [{
    "action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 0,
    "protocol" : "-1",
    "rule_no" : 100, "to_port" : 0
  }]

  default_network_acl_ingress = [{
    "action" : "allow",
    "cidr_block" : "0.0.0.0/0",
    "from_port" : 0,
    "protocol" : "-1",
    "rule_no" : 100, "to_port" : 0
  }]
}

resource "aws_vpc_endpoint" "s3" {
  vpc_id       = module.vpc.vpc_id
  service_name = "com.amazonaws.ca-central-1.s3"

  tags = {
    Name = var.s3_vpc_endpoint_name
  }
}

resource "aws_vpc_endpoint_route_table_association" "public" {
  route_table_id  = module.vpc.public_route_table_ids[0]
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

resource "aws_vpc_endpoint_route_table_association" "private" {
  route_table_id  = module.vpc.private_route_table_ids[0]
  vpc_endpoint_id = aws_vpc_endpoint.s3.id
}

# Bastion Security Group

resource "aws_security_group" "bastion" {
  name        = var.bastion_security_group_name
  description = "Bastion Host Security Group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = var.bastion_security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "bastion_ssh" {
  security_group_id = aws_security_group.bastion.id

  cidr_ipv4   = "${local.my_ip}/32"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "bastion" {
  security_group_id = aws_security_group.bastion.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

# TFE Instances Security Groups

resource "aws_security_group" "tfe" {
  name        = var.tfe_security_group_name
  description = "TFE Hosts Security Group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = var.tfe_security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "tfe_https" {
  security_group_id = aws_security_group.tfe.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

resource "aws_vpc_security_group_ingress_rule" "tfe_ssh" {
  security_group_id = aws_security_group.tfe.id

  cidr_ipv4   = "10.0.0.0/16"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "tfe" {
  security_group_id = aws_security_group.tfe.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

# Application Load Balancer Security Group

resource "aws_security_group" "alb" {
  name        = var.alb_security_group_name
  description = "Application Load Balancer Security Group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = var.alb_security_group_name
  }
}

resource "aws_vpc_security_group_ingress_rule" "alb" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "alb" {
  security_group_id = aws_security_group.alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
