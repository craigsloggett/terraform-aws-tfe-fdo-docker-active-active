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
# For testing put this in the public subnet and create a security group to limit access.

resource "aws_instance" "bastion" {
  ami           = data.aws_ami.debian.id
  instance_type = "t3a.medium"
  subnet_id     = module.vpc.private_subnets[0]

  tags = {
    Name = "Bastion Host"
  }
}

# Scaling
# resource "aws_launch_template"
# resource "aws_aws_autoscaling_group"
