variable "project" {
  type        = string
  description = "The name of the project"
}

variable "environment" {
  type        = string
  description = "The name of the environment"
}

variable "app_cpu_size" {
  type        = number
  description = "The CPU size of the ECS task"
}

variable "app_memory_size" {
  type        = number
  description = "The memory size of the ECS task"
}

variable "api_cpu_size" {
  type        = number
  description = "The CPU size of the ECS task"
}

variable "api_memory_size" {
  type        = number
  description = "The memory size of the ECS task"
}

variable "app_container_image" {
  type        = string
  description = "The image of the app container"
}

variable "app_container_port" {
  type        = number
  description = "The port of the container"
}

variable "api_container_image" {
  type        = string
  description = "The image of the api container"
}

variable "api_container_port" {
  type        = number
  description = "The port of the container"
}

variable "tags" {
  description = "Tags to apply to the resources"
  type        = map(string)
  default     = {}
}

variable "subnets" {
  type        = list(string)
  description = "List of private subnets"
}

variable "vpc_id" {
  type        = string
  description = "ID of the VPC"
}

variable "ecs_execution_role_arn" {
  type        = string
  description = "ARN of the ECS execution role"
}

variable "ecs_task_role_arn" {
  type        = string
  description = "ARN of the ECS task role"
}

variable "alb_sg_id" {
  type        = string
  description = "ID of the ALB security group"
}

variable "app_tg_arn" {
  type        = string
  description = "ARN of the ALB target group for app"
}

variable "creds_arn" {
  type        = string
  description = "ARN of the credentials secret"
}

variable "api_env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Environment variables for API"
}

variable "app_env_vars" {
  type = list(object({
    name  = string
    value = string
  }))
  description = "Environment variables for App"
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}
