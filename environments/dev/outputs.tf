output "dev_s3_bucket_name" {
  value       = module.s3_bucket.s3_bucket_name
  description = "Name of the s3 bucket"
}

output "dev_s3_bucket_arn" {
  value       = module.s3_bucket.s3_bucket_arn
  description = "ARN of the s3 bucket"
}

output "dev_networking_vpc_id" {
  value       = module.networking.networking_vpc_id
  description = "ID of the VPC"
}

output "dev_networking_public_subnet_ids" {
  value       = module.networking.networking_public_subnet_ids
  description = "IDs of the public subnets"
}

output "dev_networking_private_subnet_ids" {
  value       = module.networking.networking_private_subnet_ids
  description = "IDs of the private subnets"
}

output "dev_networking_nat_gateway_id" {
  value       = module.networking.networking_nat_gateway_id
  description = "ID of the NAT gateway"
}

output "dev_networking_elastic_ip_address" {
  value       = module.networking.networking_elastic_ip_address
  description = "Elastic IP address of NAT gateway"
}

output "dev_alb_dns_name" {
  value       = module.alb.alb_dns_name
  description = "DNS name of the ALB"
}

output "dev_app_tg_arn" {
  value       = module.alb.app_tg_arn
  description = "ARN of the ALB target group"
}

output "dev_iam_ecs_task_role_arn" {
  value       = module.iam.ecs_task_role_arn
  description = "ARN of the ECS task role"
}

output "dev_iam_ecs_execution_role_arn" {
  value       = module.iam.ecs_execution_role_arn
  description = "ARN of the ECS execution role"
}

output "dev_ecs_cluster_arn" {
  value       = module.ecs.ecs_cluster_arn
  description = "ARN of the ECS cluster"
}

output "dev_ecs_service_app_arn" {
  value       = module.ecs.ecs_service_app_arn
  description = "ARN of the ECS app service"
}

output "dev_ecs_service_api_arn" {
  value       = module.ecs.ecs_service_api_arn
  description = "ARN of the ECS api service"
}

output "dev_secretmanager_creds_arn" {
  value       = module.secretmanager.creds_arn
  description = "ARN of the credentials secret"
}
