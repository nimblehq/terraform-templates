resource "aws_lb" "main" {
  name               = "${var.namespace}-alb"
  internal           = false
  subnets            = var.subnets
  load_balancer_type = "application"
  security_groups    = var.security_group_ids

  enable_deletion_protection = true

  tags = {
    Owner = var.owner
  }
}

resource "aws_lb_listener" "http_forward" {
  load_balancer_arn = aws_lb.main.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.main.arn
  }
}

resource "aws_lb_target_group" "main" {
  name                 = "${var.namespace}-alb-tg"
  port                 = 4000
  protocol             = "HTTP"
  vpc_id               = var.vpc_id
  target_type          = "ip"
  deregistration_delay = 5

  health_check {
    healthy_threshold   = "3"
    interval            = "5"
    protocol            = "HTTP"
    matcher             = "200-299"
    timeout             = "3"
    path                = "/"
    port                = 4000
    unhealthy_threshold = "2"
  }

  tags = {
    Owner = var.owner
  }
}
