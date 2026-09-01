# AWS ALB Terraform Module

This Terraform module provisions an AWS Application Load Balancer (ALB) along with its associated Security Group, Target Group, Listener, and Listener Rules.

## Features

- **Application Load Balancer (ALB):** Provisions a public-facing HTTP/HTTPS load balancer distributed across public subnets.
- **Security Group (`aws_security_group`):** Manages inbound HTTP (port 80) and HTTPS (port 443) traffic from anywhere (`0.0.0.0/0`) and allows unrestricted outbound traffic.
- **Frontend App Target Group (`aws_lb_target_group`):** Targets IP-based ECS tasks for the frontend application with automated health checks on `/health`.
- **HTTP Listener & Listener Rules:** Listens on port 80 and forwards incoming web traffic to the application target group.

---

## Usage

```hcl
module "alb" {
  source             = "../../modules/alb"
  project            = var.project
  environment        = var.environment
  vpc_id             = module.networking.networking_vpc_id
  public_subnets     = module.networking.networking_public_subnet_ids
  app_container_port = 3000
  api_container_port = 8000
  tags = {
    Environment = var.environment
    Project     = var.project
  }
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
| [aws_lb.application_load_balancer](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb) | resource |
| [aws_security_group.alb-sg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_lb_target_group.app-tg](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_target_group) | resource |
| [aws_lb_listener.http-listener](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener) | resource |
| [aws_lb_listener_rule.app-http-rule](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/lb_listener_rule) | resource |

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | Project name | `string` | n/a | yes |
| <a name="input_environment"></a> [environment](#input\_environment) | Environment name (e.g. dev, prod) | `string` | n/a | yes |
| <a name="input_vpc_id"></a> [vpc_id](#input\_vpc\_id) | VPC ID where security group and target group are created | `string` | n/a | yes |
| <a name="input_public_subnets"></a> [public_subnets](#input\_public\_subnets) | List of public subnet IDs for placing the ALB | `list(string)` | n/a | yes |
| <a name="input_app_container_port"></a> [app_container_port](#input\_app\_container\_port) | Port exposed by the frontend application container | `number` | n/a | yes |
| <a name="input_api_container_port"></a> [api_container_port](#input\_api\_container\_port) | Port exposed by the API container | `number` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of tags to apply to created resources | `map(string)` | `{}` | no |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_alb_dns_name"></a> [alb_dns_name](#output\_alb\_dns\_name) | Public DNS name of the Application Load Balancer |
| <a name="output_app_tg_arn"></a> [app_tg_arn](#output\_app\_tg\_arn) | ARN of the frontend application target group |
| <a name="output_alb_sg_id"></a> [alb_sg_id](#output\_alb\_sg\_id) | Security group ID attached to the Application Load Balancer |
