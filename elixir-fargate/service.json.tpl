[
  {
    "name": "${namespace}",
    "image": "nginx",
    "essential": true,
    "logConfiguration": {
      "logDriver": "awslogs",
      "options": {
        "awslogs-region": "ap-southeast-1",
        "awslogs-stream-prefix": "${namespace}-service-web",
        "awslogs-group": "${aws_cloudwatch_log_group_name}"
      }
    },
    "portMappings": [
      {
        "containerPort": 80,
        "hostPort": 80,
        "protocol": "tcp"
      }
    ],
    "command": [
      "./bin/start.sh"
    ],
    "cpu": 1,
    "environment": [
    ],
    "secrets": [
    ],
    "mountPoints": [],
    "volumesFrom": []
  }
]
