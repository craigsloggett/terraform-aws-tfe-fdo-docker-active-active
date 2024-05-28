resource "aws_key_pair" "self" {
  key_name   = "tfe-public-key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAILospQ0z+2yER9Q7Jh+4X91IRU+FzztRbkYg5t9C0B6o"
}

# Bastion Host

resource "aws_instance" "bastion" {
  ami                         = data.aws_ami.debian.id
  instance_type               = "t3a.medium"
  subnet_id                   = module.vpc.public_subnets[0]
  vpc_security_group_ids      = [aws_security_group.bastion.id]
  associate_public_ip_address = true
  ebs_optimized               = true
  monitoring                  = true

  key_name                    = aws_key_pair.self.key_name
  user_data                   = file("cloud-init/bastion")
  user_data_replace_on_change = true
  iam_instance_profile        = aws_iam_instance_profile.tfe.name

  root_block_device {
    volume_type = "gp3"
    volume_size = 50
    throughput  = 125
    iops        = 3000
    encrypted   = true
  }

  metadata_options {
    http_tokens = "required"
  }

  tags = {
    Name = "Bastion Host"
  }
}

# TFE Hosts

resource "random_string" "encryption_password" {
  length = 32
}

resource "random_string" "db_password" {
  length = 32
}

resource "aws_secretsmanager_secret" "encryption_password" {
  name        = "tfe/encryption_password"
  description = "Terraform Enterprise EC2 Encryption Password"
}

resource "aws_secretsmanager_secret" "db_password" {
  name        = "tfe/db_password"
  description = "Terraform Enterprise RDS User Password"
}

resource "aws_secretsmanager_secret_version" "encryption_password" {
  secret_id     = aws_secretsmanager_secret.encryption_password.id
  secret_string = random_string.encryption_password.result
}

resource "aws_secretsmanager_secret_version" "db_password" {
  secret_id     = aws_secretsmanager_secret.db_password.id
  secret_string = random_string.db_password.result
}

resource "aws_launch_template" "tfe" {
  name                   = "tfe-web-asg-lt"
  image_id               = data.aws_ami.debian.id
  instance_type          = "t3.medium"
  key_name               = aws_key_pair.self.key_name
  update_default_version = true
  user_data = base64encode(templatefile(
    "${path.module}/scripts/tfe-host-debian-user-data.sh.tftpl",
    {
      tfe_license         = data.aws_secretsmanager_secret_version.tfe_license.secret_string
      tfe_version         = var.tfe_version
      tfe_fqdn            = local.route53_alias_record_name
      encryption_password = aws_secretsmanager_secret_version.encryption_password.secret_string
      postgresql_version  = split(".", var.postgresql_version)[0] # The install script only needs the major version number.
      rds_fqdn            = aws_db_instance.tfe.address
      db_master_username  = aws_db_instance.tfe.username
      db_master_password  = jsondecode(data.aws_secretsmanager_secret_version.master_user_secret.secret_string).password
      db_name             = aws_db_instance.tfe.db_name
      db_username         = var.rds_instance_username
      db_password         = aws_secretsmanager_secret_version.db_password.secret_string
    }
  ))

  monitoring {
    enabled = true
  }

  iam_instance_profile {
    name = aws_iam_instance_profile.tfe.name
  }

  network_interfaces {
    security_groups = [aws_security_group.tfe.id]
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
    http_tokens   = "required"
    http_endpoint = "enabled"
  }

  tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "TFE Host"
    }
  }
}

resource "aws_autoscaling_group" "tfe" {
  name                      = "tfe-web-asg"
  min_size                  = 0
  max_size                  = 1
  desired_capacity          = 1
  vpc_zone_identifier       = module.vpc.private_subnets
  health_check_grace_period = 300
  health_check_type         = "ELB"

  launch_template {
    id      = aws_launch_template.tfe.id
    version = "$Latest"
  }

  target_group_arns = [aws_lb_target_group.tfe.id]
}
