data "aws_iam_policy_document" "assume_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# TODO: Restrict permissions
data "aws_iam_policy_document" "ccf" {
  statement {
    actions   = ["s3:*"]
    effect    = "Allow"
    resources = [var.billing_data_bucket_arn, "${var.billing_data_bucket_arn}/*"]
  }
  statement {
    actions   = ["s3:*"]
    effect    = "Allow"
    resources = [var.athena_query_results_bucket_arn, "${var.athena_query_results_bucket_arn}/*"]
  }
  statement {
    actions   = ["athena:*"]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions   = ["ce:GetRightsizingRecommendation"]
    effect    = "Allow"
    resources = ["*"]
  }
  statement {
    actions   = ["glue:*"]
    effect    = "Allow"
    resources = ["*"]
  }
}

# policies

resource "aws_iam_policy" "ccf" {
  name   = "ccf-api-policy"
  policy = data.aws_iam_policy_document.ccf.json
}

# policy attachments

resource "aws_iam_role_policy_attachment" "ccf" {
  policy_arn = aws_iam_policy.ccf.arn
  role       = aws_iam_role.ccf_api_role.name
}

# role
resource "aws_iam_role" "ccf_api_role" {
  assume_role_policy = data.aws_iam_policy_document.assume_role_policy.json
  name               = "ccf-aabg-api-role"
}
