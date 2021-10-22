data "template_file" "main" {
  template = file("${path.root}/../task_definitions/service.json.tpl")

  vars = {
    namespace                     = var.namespace
    region                        = var.region
    tag                           = "latest"
    app_host                      = var.app_host
    app_port                      = var.app_port
    aws_ecr_repository            = var.aws_ecr_repository_url
    aws_parameter_store           = var.aws_ssm_parameter_arn
    aws_cloudwatch_log_group_name = var.aws_cloudwatch_log_group_name
  }
}

data "aws_iam_policy_document" "ecs_task_execution_role" {
  version = "2012-10-17"
  statement {
    sid     = ""
    effect  = "Allow"
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_policy" "ecs_task_execution_ssm" {
  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
        "ssm:GetParameters"
      ],
      "Resource": "*"
    }
  ]
}
EOF
}

resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.namespace}-ecs-execution-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_execution_role.json
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_role" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_ssm_policy" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.ecs_task_execution_ssm.arn
}

resource "aws_ecs_cluster" "main" {
  name = "${var.namespace}-ecs-cluster"

  tags = {
    Owner = var.owner
  }
}

resource "aws_ecs_task_definition" "main" {
  cpu                      = var.cpu
  memory                   = var.memory
  family                   = "${var.namespace}-service"
  network_mode             = "awsvpc"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  container_definitions    = data.template_file.main.rendered
  requires_compatibilities = ["FARGATE"]

  tags = {
    Owner = var.owner
  }
}

resource "aws_ecs_service" "main" {
  name            = "${var.namespace}-ecs-service"
  cluster         = aws_ecs_cluster.main.id
  launch_type     = "FARGATE"
  desired_count   = var.desired_count
  task_definition = aws_ecs_task_definition.main.arn

  network_configuration {
    subnets         = var.subnets
    security_groups = var.security_groups
  }

  load_balancer {
    target_group_arn = var.alb_target_group_arn
    container_name   = var.namespace
    container_port   = 4000
  }

  tags = {
    Owner = var.owner
  }

  service_registries {
    registry_arn =  var.aws_service_discovery_arn
    container_name = var.namespace
  }
}
