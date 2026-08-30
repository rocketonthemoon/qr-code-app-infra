terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.62.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

#s3 bucket creation
# module "aws_s3_bucket" {
#     source = "../../modules/s3-bucket"
#     bucket_name = "${var.project}-${var.environment}-s3-bucket"
#     environment = var.environment
#     project = var.project
#     versioning_enabled = false
#     force_destroy = true
# }

# networking infrastructure
module "networking" {
  source                    = "../../modules/networking"
  vpc_cidr_block            = var.vpc_cidr_block
  environment               = var.environment
  project                   = var.project
  number_of_public_subnets  = var.number_of_public_subnets
  number_of_private_subnets = var.number_of_private_subnets
  availability_zones        = var.availability_zones
}

# alb infrastructure
module "alb" {
  source         = "../../modules/alb"
  environment    = var.environment
  project        = var.project
  public_subnets = module.networking.networking_public_subnet_ids
  vpc_id         = module.networking.networking_vpc_id
}
