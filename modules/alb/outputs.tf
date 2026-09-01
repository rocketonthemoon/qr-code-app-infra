output "alb_dns_name" {
  description = "The DNS name of the ALB"
  value       = aws_lb.application_load_balancer.dns_name
}

output "app_tg_arn" {
  description = "The ARN of the ALB target group for app"
  value       = aws_lb_target_group.app-tg.arn
}

output "alb_sg_id" {
  description = "The ID of the ALB security group"
  value       = aws_security_group.alb-sg.id
}
