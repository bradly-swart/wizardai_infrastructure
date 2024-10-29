data "aws_iam_policy_document" "readonly_access" {
  count = var.create_bucket && length(var.readonly_access_arns) > 0 ? 1 : 0

  statement {
    sid = "AllowReadOnlyAccess"

    actions = [
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = var.readonly_access_arns
    }
  }
}

data "aws_iam_policy_document" "read_write_access" {
  count = var.create_bucket && length(var.read_write_access_arns) > 0 ? 1 : 0

  statement {
    sid = "AllowWriteAccess"

    actions = [
      "s3:PutObject",
      "s3:DeleteObject",
      "s3:GetObject",
      "s3:ListBucket"
    ]

    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*"
    ]

    principals {
      type        = "AWS"
      identifiers = var.read_write_access_arns
    }
  }
}


data "aws_iam_policy_document" "oai" {
  count = var.create_bucket && var.oai_id != "" ? 1 : 0
  statement {
    sid    = "AllowCloudFrontOAI"
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      "${aws_s3_bucket.this[0].arn}/*"
    ]

    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${var.oai_id}"
      ]
    }
  }
}
