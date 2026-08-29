variable "bucket_name" {
  description = "Name of the s3 bucket"
  type = string
}

variable "environment" {
  description = "Environment name"
  type = string
  default = "dev"
}

variable "project" {
  description = "Project name"
  type = string
  default = "app"
}

variable "tags" {
  description = "Tags to apply to the s3 bucket"
  type = map(string)
  default = {}
}

variable "enable_versioning" {
  description = "Enable versioning on the s3 bucket"
  type = bool
  default = true
}

variable "force_destroy" {
  description = "Force destroy the s3 bucket"
  type = bool
  default = false
}

variable "versioning_enabled" {
  description = "Enable versioning on the s3 bucket"
  type = bool
  default = true
}