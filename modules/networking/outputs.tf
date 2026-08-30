output "networking_vpc_id" {
  value       = aws_vpc.this.id
  description = "ID of the VPC"
}

output "networking_public_subnet_ids" {
  value       = aws_subnet.public[*].id
  description = "IDs of the public subnets"
}

output "networking_private_subnet_ids" {
  value       = aws_subnet.private[*].id
  description = "IDs of the private subnets"
}

output "networking_nat_gateway_id" {
  value       = aws_nat_gateway.this.id
  description = "ID of the NAT gateway"
}

output "networking_elastic_ip_address" {
  value       = aws_eip.nat_eip.public_ip
  description = "Elastic IP address of NAT gateway"
}

output "networking_internet_gateway_id" {
  value       = aws_internet_gateway.this.id
  description = "ID of the internet gateway"
}
