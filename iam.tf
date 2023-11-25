data "aws_iam_policy_document" "tfe_secrets" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      data.aws_secretsmanager_secret.tfe_license.arn,
      data.aws_secretsmanager_secret.tfe_encryption_password.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:ListSecrets"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_policy" "tfe_secrets" {
  name   = "TerraformEnterpriseSecretsAccess"
  path   = "/"
  policy = data.aws_iam_policy_document.tfe_secrets.json
}

data "aws_iam_policy_document" "tfe_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com"
      ]
    }
  }
}

resource "aws_iam_role" "tfe" {
  name               = "tfe-instance-role"
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.tfe_assume_role.json
}

resource "aws_iam_role_policy_attachment" "tfe_secrets" {
  role       = aws_iam_role.tfe.name
  policy_arn = aws_iam_policy.tfe_secrets.arn
}

resource "aws_iam_instance_profile" "tfe" {
  name = "tfe-instance-profile"
  path = "/"
  role = aws_iam_role.tfe.name
}
