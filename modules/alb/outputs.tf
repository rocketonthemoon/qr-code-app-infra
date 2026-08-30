output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.application_load_balancer.dns_name
}

output "alb_tg_arns" {
  description = "The ARN of the ALB target group"
  value       = [aws_lb_target_group.app-tg.arn, aws_lb_target_group.api-tg.arn]
}
