# Modify EC2 metadata.

data "aws_iam_policy_document" "ec2_modify_metadata" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:ModifyInstanceMetadataOptions"
    ]
    resources = [
      "arn:aws:ec2:${data.aws_region.current.region}:${data.aws_caller_identity.current.account_id}:instance/*"
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

# Get parameters from the SSM Parameter Store.

data "aws_iam_policy_document" "tfe_get_parameters" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:DescribeParameters",
      "ssm:GetParameter",
      "ssm:GetParametersByPath"
    ]
    resources = [
      aws_ssm_parameter.tfe_version.arn,
      aws_ssm_parameter.postgresql_major_version.arn,
      aws_ssm_parameter.tfe_encryption_password.arn,
      aws_ssm_parameter.tfe_hostname.arn,
      aws_ssm_parameter.tfe_license.arn,
      aws_ssm_parameter.tfe_database_host.arn,
      aws_ssm_parameter.tfe_database_name.arn,
      aws_ssm_parameter.tfe_database_user.arn,
      aws_ssm_parameter.tfe_database_password.arn,
      aws_ssm_parameter.tfe_redis_host.arn,
      aws_ssm_parameter.tfe_redis_password.arn,
      aws_ssm_parameter.tfe_object_storage_s3_region.arn,
      aws_ssm_parameter.tfe_object_storage_s3_bucket.arn,
    ]
  }
}

resource "aws_iam_policy" "tfe_get_parameters" {
  name   = "SSMReadTerraformEnterpriseParameters"
  path   = "/"
  policy = data.aws_iam_policy_document.tfe_get_parameters.json
}

resource "aws_iam_role_policy_attachment" "tfe_get_parameters" {
  role       = aws_iam_role.tfe.name
  policy_arn = aws_iam_policy.tfe_get_parameters.arn
}

# Put parameters into the SSM Parameter Store.

data "aws_iam_policy_document" "tfe_put_parameters" {
  statement {
    effect = "Allow"
    actions = [
      "ssm:PutParameter"
    ]
    resources = [
      aws_ssm_parameter.tfe_admin_token_url.arn,
    ]
  }
}

resource "aws_iam_policy" "tfe_put_parameters" {
  name   = "SSMWriteTerraformEnterpriseAdminTokenURLParameter"
  path   = "/"
  policy = data.aws_iam_policy_document.tfe_put_parameters.json
}

resource "aws_iam_role_policy_attachment" "tfe_put_parameters" {
  role       = aws_iam_role.tfe.name
  policy_arn = aws_iam_policy.tfe_put_parameters.arn
}

# Get secrets from Secrets Manager.

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
      aws_db_instance.tfe.master_user_secret[0].secret_arn
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
  name   = "SecretsManagerReadTerraformEnterpriseSecrets"
  path   = "/"
  policy = data.aws_iam_policy_document.tfe_secrets_manager.json
}

resource "aws_iam_role_policy_attachment" "tfe_secrets_manager" {
  role       = aws_iam_role.tfe.name
  policy_arn = aws_iam_policy.tfe_secrets_manager.arn
}

# Allow full access to the TFE S3 bucket.

data "aws_iam_policy_document" "tfe_s3" {
  statement {
    effect = "Allow"
    actions = [
      "s3:ListBucket"
    ]
    resources = [
      aws_s3_bucket.tfe.arn
    ]
  }
  statement {
    effect = "Allow"
    actions = [
      "s3:*Object"
    ]
    resources = [
      "${aws_s3_bucket.tfe.arn}/*"
    ]
  }
}

resource "aws_iam_policy" "tfe_s3" {
  name   = "S3WriteTerraformEnterpriseBucket"
  path   = "/"
  policy = data.aws_iam_policy_document.tfe_s3.json
}

resource "aws_iam_role_policy_attachment" "tfe_s3" {
  role       = aws_iam_role.tfe.name
  policy_arn = aws_iam_policy.tfe_s3.arn
}

resource "aws_iam_role_policy_attachment" "ssm_managed_instance_core" {
  role       = aws_iam_role.tfe.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Read the Uptycs sensor package from S3 (Debian instances only).
#
# The bucket name is extracted from the s3:// URI stored in var.uptycs_sensor_url.

locals {
  uptycs_s3_bucket = var.uptycs_sensor_url != null ? split("/", trimprefix(var.uptycs_sensor_url, "s3://"))[0] : ""
}

data "aws_iam_policy_document" "uptycs_s3" {
  count = var.ec2_instance_ami_name == "debian-13-amd64-20251117-2299" ? 1 : 0

  statement {
    effect  = "Allow"
    actions = ["s3:GetObject"]
    resources = [
      "arn:aws:s3:::${local.uptycs_s3_bucket}/*"
    ]
  }

  statement {
    effect  = "Allow"
    actions = ["s3:ListBucket"]
    resources = [
      "arn:aws:s3:::${local.uptycs_s3_bucket}"
    ]
  }
}

resource "aws_iam_policy" "uptycs_s3" {
  count  = var.ec2_instance_ami_name == "debian-13-amd64-20251117-2299" ? 1 : 0
  name   = "S3ReadUptycsSensorPackage"
  path   = "/"
  policy = data.aws_iam_policy_document.uptycs_s3[0].json
}

resource "aws_iam_role_policy_attachment" "uptycs_s3" {
  count      = var.ec2_instance_ami_name == "debian-13-amd64-20251117-2299" ? 1 : 0
  role       = aws_iam_role.tfe.name
  policy_arn = aws_iam_policy.uptycs_s3[0].arn
}

# Create an EC2 instance profile using the TFE role.

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
  name               = var.ec2_iam_role_name
  path               = "/"
  assume_role_policy = data.aws_iam_policy_document.tfe_assume_role.json
}

resource "aws_iam_instance_profile" "tfe" {
  name = var.ec2_instance_profile_name
  path = "/"
  role = aws_iam_role.tfe.name
}
