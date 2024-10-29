resource "aws_s3_bucket" "this" {
  count = var.create_bucket ? 1 : 0 // DesignNote: allow conditional creation here, count meta-arg cannot be used when calling the module.

  # DesignNote: Avoiding using bucket_prefix to keep the name config in one place.
  bucket = local.bucket_name

  tags = var.tags
}

resource "aws_s3_bucket_ownership_controls" "object_ownership" {
  count = var.create_bucket ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  rule {
    object_ownership = var.object_ownership
  }
}

# DesignNote: Chances are we dont want anyone to make publicly accessible buckets,
# any data publicly accessible should rather be done through and api/cloudfront
resource "aws_s3_bucket_acl" "private" {
  count = var.create_bucket ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  acl    = "private"

  depends_on = [aws_s3_bucket_ownership_controls.object_ownership]
}

resource "aws_s3_bucket_public_access_block" "private" {
  count = var.create_bucket ? 1 : 0

  bucket = aws_s3_bucket.this[0].id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true # This could affect cross account access/replication, may need to come back it if that requirement comes up.
}

resource "aws_s3_bucket_policy" "this" {
  count = var.create_bucket ? 1 : 0

  bucket = aws_s3_bucket.this[0].id
  policy = data.aws_iam_policy_document.bucket_policy[0].json
}

# DesignNote: Using source_policy_documents to allow for adding more content to bucket policy in future
data "aws_iam_policy_document" "bucket_policy" {
  count = var.create_bucket ? 1 : 0

  source_policy_documents = compact([
    data.aws_iam_policy_document.encryption_in_transit[0].json,
    var.enforce_encrypted_uploads ? data.aws_iam_policy_document.encrypted_uploads[0].json : "",
    length(var.readonly_access_arns) > 0 ? data.aws_iam_policy_document.readonly_access[0].json : "",
    length(var.read_write_access_arns) > 0 ? data.aws_iam_policy_document.read_write_access[0].json : ""
  ])
}

# TODO:
# versioning
# object locking
# update bucket policy to allow user to configure it (bring princiapl IAM role)
# lifecycle rules to manage cost
# Terraform docs
# cloudfront OAI ?
# cross-region replication
# s3 endpoints for providing access
