output "bucket_id" {
  description = "The name of the bucket."
  value       = try(aws_s3_bucket.this[0].id, "")
}

output "bucket_arn" {
  description = "S3 bucket arn"
  value       = try(aws_s3_bucket.this[0].arn, "")
}