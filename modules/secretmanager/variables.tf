variable "project" {
  type        = string
  description = "Project name"
}

variable "environment" {
  type        = string
  description = "Environment name"
}

variable "registry_username" {
  type        = string
  description = "Registry username"
}

variable "registry_password" {
  type        = string
  description = "Registry password"
}

variable "tags" {
  type        = map(string)
  description = "Tags to apply to the resource"
  default     = {}
}
