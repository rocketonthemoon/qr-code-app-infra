locals {
  api_env_vars_dev = [
    for k, v in {
      "BUCKET_NAME" = module.s3_bucket.s3_bucket_name
      "AWS_REGION"  = var.aws_region
      } : {
      name  = k
      value = tostring(v)
    }
  ]

  app_env_vars_dev = [
    for k, v in {
      "NEXT_PRIVATE_API_URL" = "http://${module.alb.alb_dns_name}"
      "PORT"                 = var.app_container_port
      } : {
      name  = k
      value = tostring(v)
    }
  ]
}
