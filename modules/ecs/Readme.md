# AWS ECS Terraform Module

This Terraform module provisions an AWS Elastic Container Service (ECS) Fargate cluster, task definitions, CloudWatch log groups, security groups, and ECS services with Service Connect for inter-service communication (service mesh).

## Features

- **ECS Cluster (`aws_ecs_cluster`):** Manages the Fargate container cluster configured with ECS Service Connect defaults.
- **Service Connect Namespace (`aws_service_discovery_http_namespace`):** Enables private HTTP-based service discovery between containers (e.g. `http://api.<namespace>:8000`).
- **Security Group (`aws_security_group`):** Restricts ingress traffic to port `3000` from the ALB security group and port `8000` for inter-task communication via Service Connect.
- **CloudWatch Logging (`aws_cloudwatch_log_group`):** Dedicated log groups for both the frontend `app` and `api` containers with 7-day retention.
- **ECS Task Definitions (`aws_ecs_task_definition`):**
  - **App Task:** Frontend application task definition with image authentication via AWS Secrets Manager.
  - **API Task:** Backend API task definition attached to an IAM task role (e.g., S3 access) and execution role.
- **ECS Fargate Services (`aws_ecs_service`):**
  - **App Service:** Deployed into private subnets, linked to the ALB target group, with Service Connect enabled.
  - **API Service:** Private backend service with Service Connect endpoint discovery (`discovery_name = "api"`).

---

## Usage

```hcl
module "ecs" {
  source                 = "../../modules/ecs"
  project                = var.project
  environment            = var.environment
  aws_region             = var.aws_region
  vpc_id                 = module.networking.networking_vpc_id
  subnets                = module.networking.networking_private_subnet_ids
  alb_sg_id              = module.alb.alb_sg_id
  app_tg_arn             = module.alb.app_tg_arn
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecs_task_role_arn      = module.iam.ecs_task_role_arn
  creds_arn              = module.secretmanager.creds_arn

  app_cpu_size        = 512
  app_memory_size     = 1024
  app_container_image = "ghcr.io/org/repo/frontend:latest"
  app_container_port  = 3000
  app_env_vars        = local.app_env_vars_dev

  api_cpu_size        = 512
  api_memory_size     = 1024
  api_container_image = "ghcr.io/org/repo/api:latest"
  api_container_port  = 8000
  api_env_vars        = local.api_env_vars_dev
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
| [aws_ecs_cluster.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_cluster) | resource |
| [aws_service_discovery_http_namespace.service-connect-namespace](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/service_discovery_http_namespace) | resource |
| [aws_security_group.ecs_tasks_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_cloudwatch_log_group.app_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_cloudwatch_log_group.api_log_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_ecs_task_definition.app-task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_task_definition.api-task](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_task_definition) | resource |
| [aws_ecs_service.app-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |
| [aws_ecs_service.api-service](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service) | resource |

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | Name of the project | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment | `string` | n/a | yes |
| <a name="input_aws_region"></a> [aws_region](#input\_aws\_region) | AWS region for CloudWatch logs | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc_id](#input\_vpc\_id) | ID of the VPC | `string` | n/a | yes |
| <a name="input_subnets"></a> [subnets](#input\_subnets) | List of private subnet IDs for tasks | `list(string)` | n/a | yes |
| <a name="input_alb_sg_id"></a> [alb_sg_id](#input\_alb\_sg\_id) | Security Group ID of the Application Load Balancer | `string` | n/a | yes |
| <a name="input_app_tg_arn"></a> [app_tg_arn](#input\_app\_tg\_arn) | Target Group ARN for the App service | `string` | n/a | yes |
| <a name="input_ecs_execution_role_arn"></a> [ecs_execution_role_arn](#input\_ecs\_execution\_role\_arn) | ARN of the ECS task execution role | `string` | n/a | yes |
| <a name="input_ecs_task_role_arn"></a> [ecs_task_role_arn](#input\_ecs\_task\_role\_arn) | ARN of the ECS task role | `string` | n/a | yes |
| <a name="input_creds_arn"></a> [creds_arn](#input\_creds\_arn) | ARN of Secrets Manager secret for container registry auth | `string` | n/a | yes |
| <a name="input_app_cpu_size"></a> [app_cpu_size](#input\_app\_cpu\_size) | CPU units for App task (e.g. 512) | `number` | n/a | yes |
| <a name="input_app_memory_size"></a> [app_memory_size](#input\_app\_memory\_size) | Memory size (MB) for App task (e.g. 1024) | `number` | n/a | yes |
| <a name="input_app_container_image"></a> [app_container_image](#input\_app\_container\_image) | App container image URI | `string` | n/a | yes |
| <a name="input_app_container_port"></a> [app_container_port](#input\_app\_container\_port) | Container port for App service | `number` | n/a | yes |
| <a name="input_app_env_vars"></a> [app_env_vars](#input\_app\_env\_vars) | Environment variables list for App container | `list(object({name=string, value=string}))` | n/a | yes |
| <a name="input_api_cpu_size"></a> [api_cpu_size](#input\_api\_cpu\_size) | CPU units for API task (e.g. 512) | `number` | n/a | yes |
| <a name="input_api_memory_size"></a> [api_memory_size](#input\_api\_memory\_size) | Memory size (MB) for API task (e.g. 1024) | `number` | n/a | yes |
| <a name="input_api_container_image"></a> [api_container_image](#input\_api\_container\_image) | API container image URI | `string` | n/a | yes |
| <a name="input_api_container_port"></a> [api_container_port](#input\_api\_container\_port) | Container port for API service | `number` | n/a | yes |
| <a name="input_api_env_vars"></a> [api_env_vars](#input\_api\_env\_vars) | Environment variables list for API container | `list(object({name=string, value=string}))` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to resources | `map(string)` | `{}` | no |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_ecs_cluster_arn"></a> [ecs_cluster_arn](#output\_ecs\_cluster\_arn) | ARN of the ECS cluster |
| <a name="output_ecs_service_app_arn"></a> [ecs_service_app_arn](#output\_ecs\_service\_app\_arn) | ARN of the frontend App ECS service |
| <a name="output_ecs_service_api_arn"></a> [ecs_service_api_arn](#output\_ecs\_service\_api\_arn) | ARN of the backend API ECS service |
| <a name="output_app_log_group_arn"></a> [app_log_group_arn](#output\_app\_log\_group\_arn) | CloudWatch log group ARN for the App service |
| <a name="output_api_log_group_arn"></a> [api_log_group_arn](#output\_api\_log\_group\_arn) | CloudWatch log group ARN for the API service |
