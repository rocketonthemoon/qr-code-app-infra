# AWS IAM Terraform Module

This Terraform module provisions IAM roles and policy attachments required by the ECS infrastructure to manage task execution, container image pull credentials, CloudWatch logging, and application S3 bucket access.

## Features

- **ECS Execution Role (`aws_iam_role.ecs_execution_role`):** 
  - Assumed by `ecs-tasks.amazonaws.com`.
  - Grants permissions to pull private container images using credentials stored in AWS Secrets Manager (`secretsmanager:GetSecretValue`).
  - Grants permissions to create CloudWatch log streams and push container logs (`logs:CreateLogStream`, `logs:PutLogEvents`, `logs:CreateLogGroup`).
- **ECS Task Role (`aws_iam_role.ecs_task_role`):**
  - Assumed by `ecs-tasks.amazonaws.com`.
  - Grants application-level permissions for S3 operations (`s3:PutObject`, `s3:GetObject`, `s3:ListBucket`, `s3:GetBucketLocation`).

---

## Usage

```hcl
module "iam" {
  source            = "../../modules/iam"
  s3_bucket_arn     = module.s3_bucket.s3_bucket_arn
  creds_arn         = module.secretmanager.creds_arn
  app_log_group_arn = module.ecs.app_log_group_arn
  api_log_group_arn = module.ecs.api_log_group_arn
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
| [aws_iam_role.ecs_execution_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_execution_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role.ecs_task_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.ecs_task_role_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_s3_bucket_arn"></a> [s3_bucket_arn](#input\_s3\_bucket\_arn) | ARN of the target S3 bucket for task application access | `string` | n/a | yes |
| <a name="input_creds_arn"></a> [creds_arn](#input\_creds\_arn) | ARN of Secrets Manager secret for container registry credentials | `string` | n/a | yes |
| <a name="input_app_log_group_arn"></a> [app_log_group_arn](#input\_app\_log\_group\_arn) | CloudWatch log group ARN for the frontend application | `string` | n/a | yes |
| <a name="input_api_log_group_arn"></a> [api_log_group_arn](#input\_api\_log\_group\_arn) | CloudWatch log group ARN for the backend API | `string` | n/a | yes |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_execution_role_arn"></a> [ecs_execution_role_arn](#output\_ecs\_execution\_role\_arn) | ARN of the ECS task execution role |
| <a name="output_ecs_task_role_arn"></a> [ecs_task_role_arn](#output\_ecs\_task\_role\_arn) | ARN of the ECS task role |
