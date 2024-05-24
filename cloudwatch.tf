resource "aws_cloudwatch_log_group" "tfe_journald" {
  name              = "tfe-journald"
  retention_in_days = 5
}
