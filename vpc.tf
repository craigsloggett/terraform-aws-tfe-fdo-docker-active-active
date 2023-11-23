data "http" "myip" {
  url = "http://ipv4.icanhazip.com"
}

locals {
  my_ip = chomp(data.http.myip.response_body)
}

module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "5.2.0"

  name = "tfe-vpc"
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
    Name = "tfe-vpce-s3"
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

# EC2 Security Groups

resource "aws_security_group" "tfe_ec2" {
  name        = "tfe-ec2-sg"
  description = "TFE Hosts Security Group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "tfe-ec2-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tfe_ec2" {
  security_group_id = aws_security_group.tfe_ec2.id

  referenced_security_group_id = aws_security_group.tfe_alb.id
  ip_protocol                  = "tcp"
  from_port                    = 80
  to_port                      = 80
}

resource "aws_vpc_security_group_ingress_rule" "tfe_ec2_ssh" {
  security_group_id = aws_security_group.tfe_ec2.id

  cidr_ipv4   = "${local.my_ip}/32"
  ip_protocol = "tcp"
  from_port   = 22
  to_port     = 22
}

resource "aws_vpc_security_group_egress_rule" "tfe_ec2" {
  security_group_id = aws_security_group.tfe_ec2.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}

# Application Load Balancer Security Group

resource "aws_security_group" "tfe_alb" {
  name        = "tfe-alb-sg"
  description = "Application Load Balancer Security Group"
  vpc_id      = module.vpc.vpc_id

  tags = {
    Name = "tfe-alb-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "tfe_alb" {
  security_group_id = aws_security_group.tfe_alb.id

  cidr_ipv4   = "${local.my_ip}/32"
  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
}

resource "aws_vpc_security_group_egress_rule" "tfe_alb" {
  security_group_id = aws_security_group.tfe_alb.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"
}
