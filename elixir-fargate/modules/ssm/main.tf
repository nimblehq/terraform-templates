locals {
  parameter_store_namespace = "/${var.namespace}/${var.environment}"
}

resource "aws_ssm_parameter" "secret_key_base" {
  name  = "${local.parameter_store_namespace}/SECRET_KEY_BASE"
  type  = "String"
  value = var.secret_key_base
}

resource "aws_ssm_parameter" "database_url" {
  name  = "${local.parameter_store_namespace}/DATABASE_URL"
  type  = "String"
  value = "postgresql://${var.rds_username}:${var.rds_password}@${var.rds_endpoint}/${var.rds_database_name}"
}
