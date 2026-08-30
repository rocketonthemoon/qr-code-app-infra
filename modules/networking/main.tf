# It has a VPC
# It has subnets (public and private)
# It has a NAT gateway
# It has a Elastic IP address for NAT gateway
# It has a public route table
# It has a private route table
# It has a public route
# It has a private route
# It has a public route table association
# It has a private route table association

#vpc resource block for creating vpc
resource "aws_vpc" "this" {
  cidr_block           = var.vpc_cidr_block
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-vpc"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

# public subnets resource block for creating public subnets
# 10.0.1.0/24 and 10.0.2.0/24
resource "aws_subnet" "public" {
  count                   = var.number_of_public_subnets
  vpc_id                  = aws_vpc.this.id
  cidr_block              = cidrsubnet(var.vpc_cidr_block, 8, count.index + 1)
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-public-subnet-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

# private subnets resource block for creating private subnets
# 10.0.3.0/24 and 10.0.4.0/24
resource "aws_subnet" "private" {
  count             = var.number_of_private_subnets
  vpc_id            = aws_vpc.this.id
  cidr_block        = cidrsubnet(var.vpc_cidr_block, 8, count.index + 3)
  availability_zone = var.availability_zones[count.index]

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-private-subnet-${count.index + 1}"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

# internet gateway resource block for creating internet gateway
resource "aws_internet_gateway" "this" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-igw"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

# nat gateway resource block for creating nat gateway
resource "aws_nat_gateway" "this" {
  depends_on    = [aws_internet_gateway.this, aws_eip.nat_eip]
  subnet_id     = aws_subnet.public[0].id
  allocation_id = aws_eip.nat_eip.id

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-nat"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

# EIP for NAT gateway
resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-nat-eip"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

# public route table
resource "aws_route_table" "public" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-public-rt"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

# private route table
resource "aws_route_table" "private" {
  vpc_id = aws_vpc.this.id

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-private-rt"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

# public internet access route
resource "aws_route" "public_internet_access" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.this.id
}

# private internet access route
resource "aws_route" "private_internet_access" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.this.id
}

# public route table association
resource "aws_route_table_association" "public" {
  count          = var.number_of_public_subnets
  route_table_id = aws_route_table.public.id
  subnet_id      = aws_subnet.public[count.index].id
}

# private route table association
resource "aws_route_table_association" "private" {
  count          = var.number_of_private_subnets
  route_table_id = aws_route_table.private.id
  subnet_id      = aws_subnet.private[count.index].id
}
