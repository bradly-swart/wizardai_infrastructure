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
variable "tags" {
  description = "Tags map added to bucket"
  type        = map(string)
  default     = {}
}