## Module Notes
### Design Notes:
Conditional bucket creation with `create_bucket` variable as count meta-arg cannot be used when calling the module.

Chances are we dont want anyone to make publicly accessible buckets,
any data publicly accessible should rather be done through and api/cloudfront

Encryption at rest:
Assume the org uses KMS for all encryption, including client-side.

If an external KMS key is used the module assumes the key's policy has the required permissions, as opposed to creating a new KMS key and managing its resource policy inside the module. It does make usability of the module more complex, the assumption that someone who needs to use a managed KMS key for encryption is willing to do the config overhead.

Downside to using the AWS managed S3 KMS key is it cannot be modified, but provides ease of use for the developer.
A bit of chicken and egg problem here in that the s3 managed key only gets created the first time an upload happens, so the EnforceEncryptedUploads policy only checks for a kms key and no specific kms key ID to allow for both configuration options.

There is also a cost consideration depending on the usage pattern and can optionally enable S3 bucket keys to reduce KMS requests.

### Future Improvements
- intelligent tiering/lifecycle rules to manage cost moving to infrequent access and glacier
- cross-region replication depending where other resources are located
- versioning should also be able to configure mfa.
- static website hosting
- transfer acceleration
- server acccess logging
- cloudtrail data events
- Additional policies - storage lense, inventory, analytics, logdelivery/access logs, explicit delete deny except for writer users.

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | 1.9.8 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | 5.73.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_acl.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_acl) | resource |
| [aws_s3_bucket_ownership_controls.object_ownership](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_ownership_controls) | resource |
| [aws_s3_bucket_policy.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_policy) | resource |
| [aws_s3_bucket_public_access_block.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_versioning.status](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.bucket_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.encrypted_uploads](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.encryption_in_transit](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.oai](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.read_write_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.readonly_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_key_enabled"></a> [bucket\_key\_enabled](#input\_bucket\_key\_enabled) | Use S3 Bucket keys for KMS server side encryption, reduce cost of requests to KMS | `bool` | `false` | no |
| <a name="input_bucket_name"></a> [bucket\_name](#input\_bucket\_name) | n/a | `string` | n/a | yes |
| <a name="input_create_bucket"></a> [create\_bucket](#input\_create\_bucket) | Enable bucket creation conditionally | `bool` | `true` | no |
| <a name="input_enforce_encrypted_uploads"></a> [enforce\_encrypted\_uploads](#input\_enforce\_encrypted\_uploads) | Enforce encrypted uploads using SSE-KMS encryption | `bool` | `true` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | n/a | `string` | n/a | yes |
| <a name="input_force_destroy"></a> [force\_destroy](#input\_force\_destroy) | Allow objects to be deleted when deleting the bucket, setting to false will cause an error when deleting and non-empty bucket | `bool` | `true` | no |
| <a name="input_oai_id"></a> [oai\_id](#input\_oai\_id) | CloudFront origin access identity ID | `string` | `""` | no |
| <a name="input_object_ownership"></a> [object\_ownership](#input\_object\_ownership) | n/a | `string` | `"BucketOwnerEnforced"` | no |
| <a name="input_read_write_access_arns"></a> [read\_write\_access\_arns](#input\_read\_write\_access\_arns) | List of users or roles to give write access to | `list(string)` | `[]` | no |
| <a name="input_readonly_access_arns"></a> [readonly\_access\_arns](#input\_readonly\_access\_arns) | List of users or roles to give read access to | `list(string)` | `[]` | no |
| <a name="input_s3_kms_key_arn"></a> [s3\_kms\_key\_arn](#input\_s3\_kms\_key\_arn) | KMS key ARN to use for S3 serverside encryption. If none is passed in S3 will create its own for SSE-KMS default encryption. | `string` | `""` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Tags map added to bucket | `map(string)` | `{}` | no |
| <a name="input_versioning"></a> [versioning](#input\_versioning) | Enable object versioning | `string` | `"Enabled"` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_bucket_arn"></a> [bucket\_arn](#output\_bucket\_arn) | S3 bucket arn |
| <a name="output_bucket_id"></a> [bucket\_id](#output\_bucket\_id) | The name of the bucket. |
<!-- END_TF_DOCS -->