variable "s3_bucket_arn" {
  description = "ARN of the S3 bucket"
  type        = string
}

variable "creds_arn" {
  description = "ARN of the credentials secret"
  type        = string
}

variable "app_log_group_arn" {
  description = "ARN of the app log group"
  type        = string
}

variable "api_log_group_arn" {
  description = "ARN of the API log group"
  type        = string
}
