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
module "s3_bucket" {
  source             = "../../modules/s3-bucket"
  bucket_name        = "${var.project}-${var.environment}-s3-bucket"
  environment        = var.environment
  project            = var.project
  versioning_enabled = false
  force_destroy      = true
}

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
  source             = "../../modules/alb"
  environment        = var.environment
  project            = var.project
  public_subnets     = module.networking.networking_public_subnet_ids
  vpc_id             = module.networking.networking_vpc_id
  app_container_port = var.app_container_port
  api_container_port = var.api_container_port
}

# iam infrastructure
module "iam" {
  source            = "../../modules/iam"
  s3_bucket_arn     = module.s3_bucket.s3_bucket_arn
  creds_arn         = module.secretmanager.creds_arn
  app_log_group_arn = module.ecs.app_log_group_arn
  api_log_group_arn = module.ecs.api_log_group_arn
}

# ecs infrastructure
module "ecs" {
  source                 = "../../modules/ecs"
  project                = var.project
  environment            = var.environment
  app_cpu_size           = var.app_cpu_size
  app_memory_size        = var.app_memory_size
  api_cpu_size           = var.api_cpu_size
  api_memory_size        = var.api_memory_size
  app_container_image    = var.app_container_image
  app_container_port     = var.app_container_port
  api_container_image    = var.api_container_image
  api_container_port     = var.api_container_port
  subnets                = module.networking.networking_private_subnet_ids
  vpc_id                 = module.networking.networking_vpc_id
  ecs_execution_role_arn = module.iam.ecs_execution_role_arn
  ecs_task_role_arn      = module.iam.ecs_task_role_arn
  alb_sg_id              = module.alb.alb_sg_id
  app_tg_arn             = module.alb.app_tg_arn
  api_tg_arn             = module.alb.api_tg_arn
  creds_arn              = module.secretmanager.creds_arn
  api_env_vars           = local.api_env_vars_dev
  app_env_vars           = local.app_env_vars_dev
  aws_region             = var.aws_region
}

# secret manager
module "secretmanager" {
  source            = "../../modules/secretmanager"
  project           = var.project
  environment       = var.environment
  registry_username = var.registry_username
  registry_password = var.registry_password
}
