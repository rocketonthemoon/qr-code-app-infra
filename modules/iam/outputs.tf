# output "s3_access_user_role_arn" {
#   description = "ARN of the s3 access user role"
#   value       = aws_iam_role.s3_access_user_role.arn
# }

output "ecs_execution_role_arn" {
  description = "ARN of the ECS execution role"
  value       = aws_iam_role.ecs_execution_role.arn
}

output "ecs_task_role_arn" {
  description = "ARN of the ECS task role"
  value       = aws_iam_role.ecs_task_role.arn
}
