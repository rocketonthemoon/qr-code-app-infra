variable "project" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "tags" {
  description = "Tags to apply to the alb"
  type        = map(string)
  default     = {}
}

variable "vpc_id" {
  description = "VPC ID"
  type        = string
}

variable "public_subnets" {
  description = "Public subnets"
  type        = list(string)
}

variable "app_container_port" {
  description = "Port of the app container"
  type        = number
}

variable "api_container_port" {
  description = "Port of the api container"
  type        = number
}

# variable "certificate_arn" {
#   description = "ACM Certificate ARN"
#   type        = string
# }
