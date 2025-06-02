resource "aws_lb" "web_alb" {
  name               = "${var.BeatStar}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [var.alb_security_group_id]
  subnets            = var.public_subnet_ids

  tags = {
    Name = "${var.BeatStar}-alb"
  }
  
  access_logs {
  bucket  = var.aws_s3_bucket_name  
  enabled = true
  prefix  = "alb-logs"
}
  enable_deletion_protection = false
}

resource "aws_lb_target_group" "web_tg" {
  name        = "${var.BeatStar}-tg"
  port        = var.container_port
  protocol    = "HTTPS"
  target_type = "ip"
  vpc_id      = var.vpc_id

  health_check {
    path                = "/"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 2
    unhealthy_threshold = 2
    matcher             = "200"
  }

  tags = {
    Name = "${var.BeatStar}-tg"
  }
}

resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.web_alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.web_tg.arn
  }
}
