output "creds_arn" {
  value       = aws_secretsmanager_secret.creds.arn
  description = "ARN of the credentials secret"
}
