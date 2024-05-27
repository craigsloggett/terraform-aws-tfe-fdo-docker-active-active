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
