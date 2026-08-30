# output "dev_s3_bucket_name" {
#   value       = module.aws_s3_bucket.s3_bucket_name
#   description = "Name of the s3 bucket"
# }

# output "dev_s3_bucket_arn" {
#   value       = module.aws_s3_bucket.s3_bucket_arn
#   description = "ARN of the s3 bucket"
# }

output "dev_networking_vpc_id" {
  value       = module.networking.networking_vpc_id
  description = "ID of the VPC"
}

output "dev_networking_public_subnet_ids" {
  value       = module.networking.networking_public_subnet_ids
  description = "IDs of the public subnets"
}

output "dev_networking_private_subnet_ids" {
  value       = module.networking.networking_private_subnet_ids
  description = "IDs of the private subnets"
}

output "dev_networking_nat_gateway_id" {
  value       = module.networking.networking_nat_gateway_id
  description = "ID of the NAT gateway"
}

output "dev_networking_elastic_ip_address" {
  value       = module.networking.networking_elastic_ip_address
  description = "Elastic IP address of NAT gateway"
}
