variable "aws_region" {
  type    = string
  default = "eu-north-1"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "project" {
  type    = string
  default = "qr-code-app"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "number_of_public_subnets" {
  description = "Number of public subnets to create"
  type        = number
  default     = 2
}

variable "number_of_private_subnets" {
  description = "Number of private subnets to create"
  type        = number
  default     = 2
}

variable "availability_zones" {
  description = "List of availability zones"
  type        = list(string)
  default     = ["eu-north-1a", "eu-north-1b"]
}

variable "app_container_image" {
  description = "Application container image"
  type        = string
}

variable "app_container_port" {
  description = "Application container port"
  type        = number
}

variable "api_container_image" {
  description = "API container image"
  type        = string
}

variable "api_container_port" {
  description = "API container port"
  type        = number
}

variable "app_cpu_size" {
  description = "Application ECS task CPU size"
  type        = number
}

variable "app_memory_size" {
  description = "Application ECS task memory size"
  type        = number
}

variable "api_cpu_size" {
  description = "API ECS task CPU size"
  type        = number
}

variable "api_memory_size" {
  description = "API ECS task memory size"
  type        = number
}

variable "registry_username" {
  description = "Registry username"
  type        = string
}

variable "registry_password" {
  description = "Registry password"
  type        = string
}
