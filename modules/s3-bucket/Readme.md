# AWS S3 Bucket Terraform Module

This Terraform module provisions a secure AWS S3 bucket configured with optional versioning, default server-side encryption (AES256), and public access blocking.

## Features

- **S3 Bucket (`aws_s3_bucket`):** Creates an S3 bucket with configurable `force_destroy` behavior.
- **Bucket Versioning (`aws_s3_bucket_versioning`):** Supports enabling or disabling bucket versioning via `versioning_enabled`.
- **Server-Side Encryption (`aws_s3_bucket_server_side_encryption_configuration`):** Enforces default server-side encryption using `AES256`.
- **Public Access Block (`aws_s3_bucket_public_access_block`):** Blocks all public ACLs and bucket policies (`block_public_acls`, `block_public_policy`, `ignore_public_acls`, `restrict_public_buckets`).

---

## Usage

```hcl
module "s3_bucket" {
  source             = "../../modules/s3-bucket"
  bucket_name        = "${var.project}-${var.environment}-s3-bucket"
  environment        = var.environment
  project            = var.project
  versioning_enabled = false
  force_destroy      = true
}
```

---

## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0.0 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | >= 6.62.0 |

---

## Resources Created

| Name | Type |
|------|------|
| [aws_s3_bucket.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket) | resource |
| [aws_s3_bucket_versioning.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_versioning) | resource |
| [aws_s3_bucket_server_side_encryption_configuration.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_server_side_encryption_configuration) | resource |
| [aws_s3_bucket_public_access_block.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/s3_bucket_public_access_block) | resource |

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_bucket_name"></a> [bucket_name](#input\_bucket\_name) | Globally unique name for the S3 bucket | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | `"dev"` | no |
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | `"app"` | no |
| <a name="input_versioning_enabled"></a> [versioning_enabled](#input\_versioning\_enabled) | Whether versioning is enabled | `bool` | `true` | no |
| <a name="input_force_destroy"></a> [force_destroy](#input\_force\_destroy) | Force destroy bucket objects on deletion | `bool` | `false` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of additional tags | `map(string)` | `{}` | no |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_s3_bucket_name"></a> [s3_bucket_name](#output\_s3\_bucket\_name) | Name (ID) of the S3 bucket |
| <a name="output_s3_bucket_arn"></a> [s3_bucket_arn](#output\_s3\_bucket\_arn) | ARN of the S3 bucket |
