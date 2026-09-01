# AWS Secrets Manager Terraform Module

This Terraform module provisions an AWS Secrets Manager secret and secret version to securely store container registry authentication credentials (e.g. GitHub Container Registry / Docker Hub) used by ECS task execution roles.

## Note

- secrets will only get deleted after 7 days by default (aws feature) even if terraform delete is run.

## Features

- **Secrets Manager Secret (`aws_secretsmanager_secret`):** Creates a secret named `${var.project}-${var.environment}-creds2` for task registry credentials.
- **Secret Version (`aws_secretsmanager_secret_version`):** Stores JSON-encoded credentials containing `username` and `password`.

---

## Usage

```hcl
module "secretmanager" {
  source            = "../../modules/secretmanager"
  project           = var.project
  environment       = var.environment
  registry_username = var.registry_username
  registry_password = var.registry_password
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
| [aws_secretsmanager_secret.creds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret) | resource |
| [aws_secretsmanager_secret_version.creds](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/secretsmanager_secret_version) | resource |

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name | `string` | n/a | yes |
| <a name="input_registry_username"></a> [registry_username](#input\_registry\_username) | Container registry username | `string` | n/a | yes |
| <a name="input_registry_password"></a> [registry_password](#input\_registry\_password) | Container registry password or personal access token | `string` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of additional tags | `map(string)` | `{}` | no |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_creds_arn"></a> [creds_arn](#output\_creds\_arn) | ARN of the created credentials secret in Secrets Manager |
