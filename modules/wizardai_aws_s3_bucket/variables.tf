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

variable "object_ownership" {
  type    = string
  default = "BucketOwnerPreferred"

  validation {
    condition     = contains(["BucketOwnerPreferred", "ObjectWriter", "BucketOwnerEnforced"], var.object_ownership)
    error_message = "Valid object_ownership values: 'BucketOwnerPreferred', 'ObjectWriter', 'BucketOwnerEnforced'."
  }
}

variable "s3_kms_key_arn" {
  type        = string
  description = "KMS key ARN to use for S3 serverside encryption. If none is pass default s3 encryption will be used."
  default     = null
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