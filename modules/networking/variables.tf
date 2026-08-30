variable "project" {
  type    = string
  default = "app"
}

variable "environment" {
  type    = string
  default = "dev"
}

variable "vpc_cidr_block" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "tags" {
  description = "Tags to apply to the VPC"
  type        = map(string)
  default     = {}
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
