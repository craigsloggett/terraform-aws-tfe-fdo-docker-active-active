data "aws_iam_policy_document" "tfe_assume_role" {
  statement {
    effect  = "Allow"
    actions = ["sts:AssumeRole"]
    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "monitoring.rds.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_role" "tfe" {
  name               = var.ec2_iam_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.tfe_assume_role.json
}

data "aws_iam_policy_document" "ec2_modify_metadata" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:ModifyInstanceMetadataOptions"
    ]
    resources = [
      "arn:aws:ec2:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:instance/*"
    ]
  }
}

resource "aws_iam_policy" "ec2_modify_metadata" {
  name   = "EC2ModifyInstanceMetadataOptions"
  path   = "/"
  policy = data.aws_iam_policy_document.ec2_modify_metadata.json
}

resource "aws_iam_role_policy_attachment" "ec2_modify_metadata" {
  role       = aws_iam_role.tfe.name
  policy_arn = aws_iam_policy.ec2_modify_metadata.arn
}

data "aws_iam_policy_document" "tfe_ssm" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]
    resources = [
      aws_ssm_parameter.tfe_license.arn,
      aws_ssm_parameter.tfe_version.arn,
      aws_ssm_parameter.tfe_encryption_password.arn,
      aws_ssm_parameter.tfe_fqdn.arn,
      aws_ssm_parameter.tfe_db_name.arn,
      aws_ssm_parameter.tfe_db_username.arn,
      aws_ssm_parameter.tfe_db_password.arn,
      aws_ssm_parameter.postgresql_major_version.arn,
      aws_ssm_parameter.rds_fqdn.arn,
      aws_ssm_parameter.s3_region.arn,
      aws_ssm_parameter.s3_bucket_id.arn
    ]
  }
}

resource "aws_iam_policy" "tfe_ssm" {
  name   = "ReadTerraformEnterpriseSystemsManagerParameters"
  path   = "/"
  policy = data.aws_iam_policy_document.tfe_ssm.json
}

resource "aws_iam_role_policy_attachment" "tfe_ssm" {
  role       = aws_iam_role.tfe.name
  policy_arn = aws_iam_policy.tfe_ssm.arn
}

data "aws_iam_policy_document" "tfe_secrets_manager" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetResourcePolicy",
      "secretsmanager:GetSecretValue",
      "secretsmanager:DescribeSecret",
      "secretsmanager:ListSecretVersionIds"
    ]
    resources = [
      data.aws_secretsmanager_secret_version.master_user_secret.arn,
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

resource "aws_iam_policy" "tfe_secrets_manager" {
  name   = "ReadTerraformEnterpriseSecretsManagerSecrets"
  path   = "/"
  policy = data.aws_iam_policy_document.tfe_secrets_manager.json
}

resource "aws_iam_role_policy_attachment" "tfe_secrets_manager" {
  role       = aws_iam_role.tfe.name
  policy_arn = aws_iam_policy.tfe_secrets_manager.arn
}

data "aws_iam_policy_document" "tfe_s3" {
  statement {
    effect = "Allow"
    actions = [
      "s3:*"
    ]
    resources = [
      aws_s3_bucket.tfe.arn
    ]
  }
}

resource "aws_iam_policy" "tfe_s3" {
  name   = "FullTerraformEnterpriseS3Bucket"
  path   = "/"
  policy = data.aws_iam_policy_document.tfe_s3.json
}

resource "aws_iam_role_policy_attachment" "tfe_s3" {
  role       = aws_iam_role.tfe.name
  policy_arn = aws_iam_policy.tfe_s3.arn
}

resource "aws_iam_instance_profile" "tfe" {
  name = var.ec2_instance_profile_name
  path = "/"
  role = aws_iam_role.tfe.name
}
