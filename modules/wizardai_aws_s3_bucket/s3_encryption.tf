# DesignNote: S3 encrypts at rest by default, we may want to use a managed kms key for encryption instead.
resource "aws_s3_bucket_server_side_encryption_configuration" "kms" {
  count = var.create_bucket && var.s3_kms_key_arn != "null" ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  rule {
    apply_server_side_encryption_by_default {
      kms_master_key_id = var.s3_kms_key_arn
      sse_algorithm     = "aws:kms"
    }
  }
}

# Policy sourced from:
# https://repost.aws/knowledge-center/s3-bucket-policy-for-config-rule
# https://repost.aws/knowledge-center/s3-enforce-modern-tls

data "aws_iam_policy_document" "encryption_in_transit" {
  count = var.create_bucket ? 1 : 0

  statement {
    sid    = "EnforceTLSv12orHigher"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "NumericLessThan"
      variable = "s3:TlsVersion"
      values = [
        "1.2"
      ]
    }
  }

  statement {
    sid    = "AllowSSLRequestsOnly"
    effect = "Deny"

    actions = [
      "s3:*",
    ]

    resources = [
      aws_s3_bucket.this[0].arn,
      "${aws_s3_bucket.this[0].arn}/*",
    ]

    principals {
      type        = "*"
      identifiers = ["*"]
    }

    condition {
      test     = "Bool"
      variable = "aws:SecureTransport"
      values = [
        "false"
      ]
    }
  }
}
