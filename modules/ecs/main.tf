// ecs tasks security group
// allow traffic from alb to access ports 3000 from private subnets
resource "aws_security_group" "ecs_tasks_security_group" {
  name        = "${var.project}-${var.environment}-ecs-tasks-sg"
  description = "Security group for ECS tasks"
  vpc_id      = var.vpc_id

  ingress {
    from_port       = 3000
    to_port         = 3000
    protocol        = "tcp"
    description     = "Allow all inbound traffic on port 3000 from alb"
    security_groups = [var.alb_sg_id]
  }

  ingress {
    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    description = "Allow internal traffic on port 8000 between ECS tasks via service connect"
    self        = true
  }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
    description      = "Allow all outbound traffic"
  }

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-ecs-tasks-security-group"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

resource "aws_service_discovery_http_namespace" "service-connect-namespace" {
  name        = "${var.project}-${var.environment}-service-connect-namespace"
  description = "Service connect namespace for ECS tasks"

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-service-connect-namespace"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

// ecs cluster creation
resource "aws_ecs_cluster" "cluster" {
  name = "${var.project}-${var.environment}-ecs-cluster"

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-ecs-cluster"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })

  service_connect_defaults {
    namespace = aws_service_discovery_http_namespace.service-connect-namespace.arn
  }

}

// logging configuration
resource "aws_cloudwatch_log_group" "app_log_group" {
  name              = "/ecs/${var.project}-${var.environment}-app"
  retention_in_days = 7
}

resource "aws_cloudwatch_log_group" "api_log_group" {
  name              = "/ecs/${var.project}-${var.environment}-api"
  retention_in_days = 7
}

// ecs app task definition
resource "aws_ecs_task_definition" "app-task" {
  family                   = "${var.project}-${var.environment}-app-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.app_cpu_size
  memory                   = var.app_memory_size
  execution_role_arn       = var.ecs_execution_role_arn

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-app-task"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })

  container_definitions = jsonencode([
    {
      name        = "app"
      image       = var.app_container_image
      essential   = true
      environment = var.app_env_vars
      portMappings = [
        {
          containerPort = var.app_container_port
          hostPort      = var.app_container_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.app_log_group.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      repositoryCredentials = {
        credentialsParameter = var.creds_arn
      }
    }
  ])
}

// ecs api task definition
resource "aws_ecs_task_definition" "api-task" {
  family                   = "${var.project}-${var.environment}-api-task"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  cpu                      = var.api_cpu_size
  memory                   = var.api_memory_size
  execution_role_arn       = var.ecs_execution_role_arn
  task_role_arn            = var.ecs_task_role_arn

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-api-task"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })

  container_definitions = jsonencode([
    {
      name        = "api"
      image       = var.api_container_image
      essential   = true
      environment = var.api_env_vars
      portMappings = [
        {
          name          = "api-port"
          containerPort = var.api_container_port
          hostPort      = var.api_container_port
        }
      ]
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          "awslogs-group"         = aws_cloudwatch_log_group.api_log_group.name
          "awslogs-region"        = var.aws_region
          "awslogs-stream-prefix" = "ecs"
        }
      }
      repositoryCredentials = {
        credentialsParameter = var.creds_arn
      }
    }
  ])
}

// ecs app service
resource "aws_ecs_service" "app-service" {
  name            = "${var.project}-${var.environment}-app-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.app-task.arn
  desired_count   = 2
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_security_group.id]
    subnets          = var.subnets
    assign_public_ip = false
  }

  // attaching alb target group for app
  load_balancer {
    target_group_arn = var.app_tg_arn
    container_name   = "app"
    container_port   = var.app_container_port
  }

  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.service-connect-namespace.arn
  }

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-app-service"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}

// ecs api service
resource "aws_ecs_service" "api-service" {
  name            = "${var.project}-${var.environment}-api-service"
  cluster         = aws_ecs_cluster.cluster.id
  task_definition = aws_ecs_task_definition.api-task.arn
  desired_count   = 1
  launch_type     = "FARGATE"

  network_configuration {
    security_groups  = [aws_security_group.ecs_tasks_security_group.id]
    subnets          = var.subnets
    assign_public_ip = false
  }

  service_connect_configuration {
    enabled   = true
    namespace = aws_service_discovery_http_namespace.service-connect-namespace.arn

    service {
      port_name      = "api-port"
      discovery_name = "api" # Resolves to http://api.${aws_service_connect_namespace.service-connect-namespace.name}:8000 inside the cluster
      client_alias {
        port = var.api_container_port
      }
    }
  }

  tags = merge(var.tags, {
    Name        = "${var.project}-${var.environment}-api-service"
    Environment = var.environment
    Project     = var.project
    ManagedBy   = "Terraform"
  })
}


