variable "namespace" {
  type = string
}

variable "region" {
  type = string
}

variable "app_host" {
  description = "Application host name"
}

variable "app_port" {
  description = "Application port"
}

variable "aws_ecr_repository_url" {
  description = "Amazon ECR repository URL"
}

variable "aws_ssm_parameter_arn" {
  description = "Amazon SSM Parameter Store"
}

variable "subnets" {
  description = "Subnet where ECS placed"
  type        = list(any)
}

variable "security_groups" {
  description = "One or more VPC security groups associated with ECS cluster"
  type        = list(string)
}

variable "alb_target_group_arn" {
  description = "ALB target group ARN"
}

variable "cpu" {
  type = number
}

variable "memory" {
  type = number
}

variable "desired_count" {
  type = number
}

variable "aws_cloudwatch_log_group_name" {
  description = "AWS CloudWatch Log Group name"
}

variable "owner" {
  type = string
}

variable "environment" {
  type = string
}

variable "aws_service_discovery_arn" {
  description = "AWS Service Discovery"
}