variable "app_name" {
  description = "App Name"
  default     = "codewar-web-staging"
}

variable "region" {
  default = "ap-southeast-1"
}

variable "owner" {
  default = "codewar-web"
}

variable "environment" {
  default = "staging"
}

variable "rds_instance_type" {
  default = "db.t2.micro"
}

variable "rds_database_name" {
  default = "codewarWeb"
}

variable "rds_username" {
  default = "codewar_web_staging"
}

variable "rds_password" {
  default = "NIEzVjznMIvcDUol"
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
  default = "arn:aws:ssm:ap-southeast-1:301618631622:parameter/codewar-web/staging"
}
