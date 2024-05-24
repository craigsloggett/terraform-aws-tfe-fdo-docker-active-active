# Bastion Host

resource "aws_cloudwatch_log_group" "bastion_journald" {
  name              = "bastion-journald"
  retention_in_days = 5
}

resource "aws_cloudwatch_log_stream" "bastion_journald" {
  name           = "bastion-journald"
  log_group_name = aws_cloudwatch_log_group.bastion_journald.name
}

# TFE Hosts

resource "aws_cloudwatch_log_group" "tfe_journald" {
  name              = "tfe-journald"
  retention_in_days = 5
}

resource "aws_cloudwatch_log_stream" "tfe_journald" {
  name           = "tfe-journald"
  log_group_name = aws_cloudwatch_log_group.tfe_journald.name
}
