# security group for ALB
# allows ingress on port 80 and 443 from anywhere to ALB
# allows egress to anywhere
resource "aws_security_group" "alb-sg" {
  name        = "${var.project}-${var.environment}-alb-sg"
  description = "Security group for ALB"
  vpc_id      = var.vpc_id

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-alb-sg"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

# Application Load Balancer
resource "aws_lb" "application_load_balancer" {
  name               = "${var.project}-${var.environment}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [aws_security_group.alb-sg.id]

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-alb"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

# target group for frontend app
# port 3000
# health check on /health
# expected response code 200
# interval 30 seconds
# timeout 5 seconds
# healthy threshold 3
# unhealthy threshold 3
resource "aws_lb_target_group" "app-tg" {
  name        = "${var.project}-${var.environment}-app-tg"
  target_type = "ip"
  port        = var.app_container_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id

  health_check {
    enabled             = true
    healthy_threshold   = 3
    interval            = 30
    timeout             = 5
    matcher             = "200"
    path                = "/health"
    port                = "traffic-port"
    protocol            = "HTTP"
    unhealthy_threshold = 3
  }

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-app-tg"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

# listener for HTTP port 80
resource "aws_lb_listener" "http-listener" {
  load_balancer_arn = aws_lb.application_load_balancer.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}

# listener for HTTPS port 443
# resource "aws_lb_listener" "https-listener" {
#   load_balancer_arn = aws_lb.application_load_balancer.arn
#   port              = "443"
#   protocol          = "HTTPS"

#   certificate_arn = var.certificate_arn

#   default_action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app.arn
#   }
# }

# path based HTTP routing for frontend app
resource "aws_lb_listener_rule" "app-http-rule" {
  listener_arn = aws_lb_listener.http-listener.arn
  priority     = 2

  condition {
    path_pattern {
      values = ["/*"]
    }
  }

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app-tg.arn
  }
}

# path based HTTPS routing for frontend app
# resource "aws_lb_listener_rule" "app-https-rule" {
#   listener_arn = aws_lb_listener.https-listener.arn
#   priority     = 2

#   condition {
#     path_pattern {
#       values = ["/*"]
#     }
#   }

#   action {
#     type             = "forward"
#     target_group_arn = aws_lb_target_group.app-tg.arn
#   }
# }
