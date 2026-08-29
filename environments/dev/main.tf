terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.62.0"
    }
  }
}

provider "aws" {
  region     = "${var.aws_region}"
}

module "aws_s3_bucket" {
    source = "../../modules/s3-bucket"
    bucket_name = "${var.project}-${var.environment}-s3-bucket"
    environment = var.environment
    project = var.project
    versioning_enabled = false
    force_destroy = true
}

