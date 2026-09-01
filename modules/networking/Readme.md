# AWS Networking Terraform Module

This Terraform module provisions a core AWS networking infrastructure including a Virtual Private Cloud (VPC), public and private subnets across multiple Availability Zones, an Internet Gateway, a NAT Gateway with an Elastic IP, and route tables for public and private internet routing.

## Features

- **VPC (`aws_vpc`):** Custom CIDR block with DNS support and DNS hostnames enabled.
- **Public Subnets (`aws_subnet`):** Configured to automatically map public IPs on launch, distributed across requested Availability Zones.
- **Private Subnets (`aws_subnet`):** Isolated subnets for internal resources (e.g., ECS tasks), routed through the NAT Gateway.
- **Internet Gateway (`aws_internet_gateway`):** Provides public internet access for resources in public subnets.
- **NAT Gateway & Elastic IP (`aws_nat_gateway`, `aws_eip`):** Allows outbound internet traffic from private subnets (e.g., for pulling container images or external dependencies) while blocking inbound connections.
- **Route Tables & Associations (`aws_route_table`, `aws_route`):** Separate route tables for public and private subnets with default `0.0.0.0/0` routes.

---

## Usage

```hcl
module "networking" {
  source                    = "../../modules/networking"
  project                   = var.project
  environment               = var.environment
  vpc_cidr_block            = "10.0.0.0/16"
  number_of_public_subnets  = 2
  number_of_private_subnets = 2
  availability_zones        = ["eu-north-1a", "eu-north-1b"]
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
| [aws_vpc.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/vpc) | resource |
| [aws_subnet.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_subnet.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/subnet) | resource |
| [aws_internet_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/internet_gateway) | resource |
| [aws_nat_gateway.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/nat_gateway) | resource |
| [aws_eip.nat_eip](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eip) | resource |
| [aws_route_table.public](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route_table.private](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route_table) | resource |
| [aws_route.public_internet_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |
| [aws_route.private_internet_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/route) | resource |

---

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_project"></a> [project](#input\_project) | Name of the project | `string` | `"app"` | no |
| <a name="input_environment"></a> [environment](#input\_environment) | Name of the environment | `string` | `"dev"` | no |
| <a name="input_vpc_cidr_block"></a> [vpc_cidr_block](#input\_vpc\_cidr\_block) | Primary CIDR block for the VPC | `string` | `"10.0.0.0/16"` | no |
| <a name="input_number_of_public_subnets"></a> [number_of_public_subnets](#input\_number\_of\_public\_subnets) | Number of public subnets to create | `number` | `2` | no |
| <a name="input_number_of_private_subnets"></a> [number_of_private_subnets](#input\_number\_of\_private\_subnets) | Number of private subnets to create | `number` | `2` | no |
| <a name="input_availability_zones"></a> [availability_zones](#input\_availability\_zones) | List of availability zones for subnet placement | `list(string)` | `["eu-north-1a", "eu-north-1b"]` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | Map of additional tags to apply to resources | `map(string)` | `{}` | no |

---

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_networking_vpc_id"></a> [networking_vpc_id](#output\_networking\_vpc\_id) | ID of the created VPC |
| <a name="output_networking_public_subnet_ids"></a> [networking_public_subnet_ids](#output\_networking\_public\_subnet\_ids) | List of IDs of the public subnets |
| <a name="output_networking_private_subnet_ids"></a> [networking_private_subnet_ids](#output\_networking\_private\_subnet\_ids) | List of IDs of the private subnets |
| <a name="output_networking_nat_gateway_id"></a> [networking_nat_gateway_id](#output\_networking\_nat\_gateway\_id) | ID of the NAT gateway |
| <a name="output_networking_elastic_ip_address"></a> [networking_elastic_ip_address](#output\_networking\_elastic\_ip\_address) | Public Elastic IP address assigned to the NAT gateway |
| <a name="output_networking_internet_gateway_id"></a> [networking_internet_gateway_id](#output\_networking\_internet\_gateway\_id) | ID of the Internet gateway |
