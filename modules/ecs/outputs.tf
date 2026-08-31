output "ecs_cluster_arn" {
  value       = aws_ecs_cluster.cluster.arn
  description = "ARN of the ECS cluster"
}

output "ecs_service_app_arn" {
  value       = aws_ecs_service.app-service.arn
  description = "ARN of the ECS app service"
}

output "ecs_service_api_arn" {
  value       = aws_ecs_service.api-service.arn
  description = "ARN of the ECS api service"
}

output "app_log_group_arn" {
  value       = aws_cloudwatch_log_group.app_log_group.arn
  description = "ARN of the app log group"
}

output "api_log_group_arn" {
  value       = aws_cloudwatch_log_group.api_log_group.arn
  description = "ARN of the api log group"
}
