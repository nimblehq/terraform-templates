// ALB
resource "aws_security_group" "alb" {
  name        = "${var.namespace}-alb-sg"
  description = "ALB Security Group"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.namespace}-alb-sg"
    Owner       = var.owner
    Environment = var.environment
  }
}

// ECS
resource "aws_security_group" "ecs_fargate" {
  name        = "${var.namespace}-ecs-fargate-sg"
  description = "ECS Fargate Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.namespace}-ecs-fargate-sg"
    Owner       = var.owner
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "ecs_fargate_egress_anywhere" {
  type              = "egress"
  security_group_id = aws_security_group.ecs_fargate.id
  protocol          = "-1"
  from_port         = 0
  to_port           = 0
  cidr_blocks       = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "ecs_fargate_ingress_alb" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs_fargate.id
  protocol                 = "tcp"
  from_port                = 4000
  to_port                  = 4000
  source_security_group_id = aws_security_group.alb.id
}

resource "aws_security_group_rule" "ecs_fargate_ingress_private" {
  type                     = "ingress"
  security_group_id        = aws_security_group.ecs_fargate.id
  protocol                 = "-1"
  from_port                = 0
  to_port                  = 65535
  cidr_blocks              = var.private_subnets_cidr_blocks
}

// RDS
resource "aws_security_group" "rds" {
  name        = "${var.namespace}-rds"
  description = "RDS Security Group"
  vpc_id      = var.vpc_id

  tags = {
    Name        = "${var.namespace}-rds-sg"
    Owner       = var.owner
    Environment = var.environment
  }
}

resource "aws_security_group_rule" "rds_ingress_app_instance" {
  type                     = "ingress"
  security_group_id        = aws_security_group.rds.id
  from_port                = 5432
  to_port                  = 5432
  protocol                 = "tcp"
  source_security_group_id = aws_security_group.ecs_fargate.id
}
