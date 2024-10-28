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
