variable "bucket_name" {
  type = string
}

variable "environment" {
  type = string

  validation {
    condition     = contains(["development", "staging", "production"], var.environment)
    error_message = "Valid environment values: 'development', 'staging', 'production'."
  }
}

variable "create_bucket" {
  type        = bool
  description = "Enable bucket creation conditionally"
  default     = true
}

variable "force_destroy" {
  type        = bool
  description = "Allow objects to be deleted when deleting the bucket, setting to false will cause an error when deleting and non-empty bucket"
  default     = true
}

variable "versioning" {
  type        = string
  description = "Enable object versioning"
  default     = "Enabled"

  validation {
    condition     = contains(["Enabled", "Disabled"], var.versioning)
    error_message = "Valid versioning values: 'Enabled', 'Disabled'."
  }
}

variable "object_ownership" {
  type    = string
  default = "BucketOwnerEnforced"

  validation {
    condition     = contains(["BucketOwnerPreferred", "ObjectWriter", "BucketOwnerEnforced"], var.object_ownership)
    error_message = "Valid object_ownership values: 'BucketOwnerPreferred', 'ObjectWriter', 'BucketOwnerEnforced'."
  }
}

variable "s3_kms_key_arn" {
  type        = string
  description = "KMS key ARN to use for S3 serverside encryption. If none is pass default s3 encryption will be used."
  default     = ""
}

variable "bucket_key_enabled" {
  type        = bool
  description = "Use S3 Bucket keys for KMS server side encryption, reduce cost of requests to KMS"
  default     = false
}

variable "enforce_encrypted_uploads" {
  type        = bool
  description = "Enforce encrypted uploads using SSE-KMS encryption"
  default     = false
}

variable "tags" {
  description = "Tags map added to bucket"
  type        = map(string)
  default     = {}
}

variable "readonly_access_arns" {
  type        = list(string)
  description = "List of users or roles to give read access to"
  default     = []
}

variable "read_write_access_arns" {
  type        = list(string)
  description = "List of users or roles to give write access to"
  default     = []
}

variable "oai_id" {
  type        = string
  description = "CloudFront origin access identity ID"
  default     = ""
}