# Using the RDS instance name variable to avoid cyclical dependencies.

resource "aws_cloudwatch_log_group" "tfe_rds_postgresql" {
  name              = "/aws/rds/instance/${var.rds_instance_name}/postgresql"
  retention_in_days = 30

  tags = {
    Name = "${var.rds_instance_name}-postgresql-logs"
  }
}

resource "aws_cloudwatch_log_group" "tfe_rds_upgrade" {
  name              = "/aws/rds/instance/${var.rds_instance_name}/upgrade"
  retention_in_days = 30

  tags = {
    Name = "${var.rds_instance_name}-upgrade-logs"
  }
}
