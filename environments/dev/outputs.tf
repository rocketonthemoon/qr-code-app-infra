output "dev_s3_bucket_name" {
  value       = module.aws_s3_bucket.s3_bucket_name
  description = "Name of the s3 bucket"
}

output "dev_s3_bucket_arn" {
  value       = module.aws_s3_bucket.s3_bucket_arn
  description = "ARN of the s3 bucket"
}