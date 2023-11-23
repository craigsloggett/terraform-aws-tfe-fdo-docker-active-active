data "aws_ami" "debian" {
  most_recent = true
  owners      = ["136693071363"]

  filter {
    name   = "name"
    values = ["debian-12-amd64-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# Single Node

resource "aws_key_pair" "self" {
  key_name   = "public-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2/hbsAhrsTGuRaQZCMxnCYjpBtjCj9ekXMiY2dq6Yr"
}

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.debian.id
  instance_type               = "t3a.medium"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = "true"

  key_name                    = aws_key_pair.self.key_name
  user_data                   = file("cloud-init/bastion")
  user_data_replace_on_change = "true"

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "Bastion Host"
  }
}

# Scaling
# resource "aws_launch_template"
# resource "aws_aws_autoscaling_group"
