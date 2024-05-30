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

data "aws_iam_policy_document" "tfe_ec2_metadata" {
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

resource "aws_iam_policy" "tfe_ec2_metadata" {
  name   = "TerraformEnterpriseEC2Metadata"
  path   = "/"
  policy = data.aws_iam_policy_document.tfe_ec2_metadata.json
}

resource "aws_iam_role_policy_attachment" "tfe_ec2_metadata" {
  role       = aws_iam_role.tfe.name
  policy_arn = aws_iam_policy.tfe_ec2_metadata.arn
}

resource "aws_iam_instance_profile" "tfe" {
  name = var.ec2_instance_profile_name
  path = "/"
  role = aws_iam_role.tfe.name
}
