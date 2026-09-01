resource "aws_secretsmanager_secret" "creds" {
  name        = "${var.project}-${var.environment}-creds2"
  description = "credentials for ECS tasks to pull images from registry"

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-creds2"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })

  lifecycle {

  }

}

resource "aws_secretsmanager_secret_version" "creds" {
  secret_id = aws_secretsmanager_secret.creds.id
  secret_string = jsonencode({
    username = var.registry_username
    password = var.registry_password
  })
}
