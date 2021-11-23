variable "app_name" {
  description = "Application name"
}

variable "region" {
  default = "ap-southeast-1"
}

variable "owner" {
  default = "nimble"
}

variable "environment" {
  default = "staging"
}

variable "rds_instance_type" {
  default = "db.t2.micro"
}

variable "rds_database_name" {
  description = "RDS database name"
  default = "SampleElixirAppStagingDb"
}

variable "rds_username" {
  description = "RDS username"
}

variable "rds_password" {
  description = "RDS password"
}

variable "ecs_cpu" {
  default = 256
}

variable "ecs_memory" {
  default = 512
}

variable "ecs_desired_count" {
  default = 2
}

variable "aws_ssm_parameter_arn" {
  description = "Amazon SSM parameter store"
}
