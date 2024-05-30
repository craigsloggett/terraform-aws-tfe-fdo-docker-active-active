resource "aws_db_subnet_group" "tfe" {
  name       = "main"
  subnet_ids = module.vpc.private_subnets

  tags = {
    Name = "main"
  }
}

resource "aws_db_instance" "tfe" {
  identifier                    = var.rds_instance_name
  engine                        = "postgres"
  engine_version                = var.postgresql_version
  instance_class                = var.rds_instance_class
  db_name                       = var.tfe_db_name
  username                      = var.rds_instance_master_username
  manage_master_user_password   = true
  master_user_secret_kms_key_id = data.aws_kms_key.secretsmanager.arn
  db_subnet_group_name          = aws_db_subnet_group.tfe.name
  vpc_security_group_ids        = [aws_security_group.rds.id]
  multi_az                      = true
  backup_retention_period       = 4
  allocated_storage             = 20
  max_allocated_storage         = 100
  skip_final_snapshot           = true

  tags = {
    Name = var.rds_instance_name
  }
}
