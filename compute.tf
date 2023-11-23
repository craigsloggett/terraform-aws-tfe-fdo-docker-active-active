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

resource "aws_key_pair" "self" {
  key_name   = "public-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIM2/hbsAhrsTGuRaQZCMxnCYjpBtjCj9ekXMiY2dq6Yr"
}

# Single Node
#resource "aws_instance" "bastion" {
#  ami                         = data.aws_ami.debian.id
#  instance_type               = "t3a.medium"
#  subnet_id                   = module.vpc.public_subnets[0]
#  vpc_security_group_ids      = [aws_security_group.bastion.id]
#  associate_public_ip_address = true
#
#  key_name                    = aws_key_pair.self.key_name
#  user_data                   = file("cloud-init/bastion")
#  user_data_replace_on_change = true
#
#  metadata_options {
#    http_tokens = "required"
#  }
#
#  tags = {
#    Name = "Bastion Host"
#  }
#}

# Scaling
resource "aws_launch_template" "tfe" {
  name          = "tfe-web-asg-lt"
  image_id      = data.aws_ami.debian.id
  instance_type = "t3.medium"
  key_name      = aws_key_pair.self.key_name
  user_data     = base64encode(file("cloud-init/bastion"))

  network_interfaces {
    associate_public_ip_address = true
    security_groups             = [aws_security_group.tfe_ec2.id]
  }

  block_device_mappings {
    device_name = "/dev/xvda"

    ebs {
      volume_type = "gp3"
      volume_size = 50
      throughput  = 125
      iops        = 3000
      encrypted   = true
    }
  }

  metadata_options {
    http_tokens                 = "required"
    http_endpoint               = "enabled"
    http_put_response_hop_limit = 2
  }
}

resource "aws_autoscaling_group" "tfe" {
  name                      = "tfe-web-asg"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = module.vpc.public_subnets
  health_check_grace_period = 900
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.tfe.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tfe.id]
}
