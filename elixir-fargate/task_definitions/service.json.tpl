[
  {
    "name": "${namespace}",
    "image": "${aws_ecr_repository}:${tag}",
    "memory": 256,
    "essential": true,
    "cpu": 1,
    "portMappings": [
      {
        "containerPort": ${app_port},
        "hostPort": ${app_port}
      }
    ],
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "${region}",
        "awslogs-stream-prefix": "${namespace}-service-web",
        "awslogs-group": "${aws_cloudwatch_log_group_name}"
      }
    },
    "environment": [
      {
        "name": "HOST",
        "value": "${app_host}"
      },
      {
        "name": "PORT",
        "value": "${app_port}"
      }
    ],
    "secrets": [
      {
        "name": "DATABASE_URL",
        "valueFrom": "${database_url_ssm_arn}"
      },
      {
        "name": "SECRET_KEY_BASE",
        "valueFrom": "${secret_base_ssm_arn}"
      }
    ]
  }
]
