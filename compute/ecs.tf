resource "aws_ecs_cluster" "main" {
  name = "${var.BeatStar}-ecs-cluster"

  tags = {
    Name = "${var.BeatStar}-ecs-cluster"
  }
  setting {
  name  = "containerInsights"
  value = "enabled"
  }

}

resource "aws_ecs_task_definition" "web_app" {
  family                   = "${var.BeatStar}-task"
  cpu                      = var.cpu
  memory                   = var.memory
  network_mode            = "awsvpc"
  requires_compatibilities = ["FARGATE"]
  execution_role_arn      = var.task_execution_role_arn

  container_definitions = jsonencode([
    {
      name      = "web-app"
      image     = "nginx:latest",
      portMappings = [
        {
          containerPort = var.container_port
          hostPort      = var.container_port
          protocol      = "tcp"
        }
      ],
      essential = true
    }
  ])
}

resource "aws_ecs_service" "web_service" {
  name            = "${var.BeatStar}-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  task_definition = aws_ecs_task_definition.web_app.arn
  desired_count   = var.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = var.private_subnet_ids
    security_groups = [var.ecs_security_group_id]
    assign_public_ip = false
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.web_tg.arn
    container_name   = "web-app"
    container_port   = var.container_port
  }

  deployment_controller {
    type = "ECS"
  }

  depends_on = [aws_lb_listener.http]
}
