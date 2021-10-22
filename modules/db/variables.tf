variable "namespace" {
  type = string
}

variable "engine" {
  default = "postgres"
}

variable "engine_version" {
  default = "11.12"
}

variable "instance_type" {
  type = string
}

variable "vpc_security_group_ids" {
  type = list(string)
}

variable "vpc_id" {
  type = string
}

variable "database_name" {
  type = string
}

variable "username" {
  type = string
}

variable "password" {
  type = string
}

variable "subnet_ids" {
  type = list(any)
}

variable "port" {
  default = 5432
}

variable "publicly_accessible" {
  default = false
}

variable "storage_encrypted" {
  default = false
}

variable "create_random_password" {
  default = false
}

variable "create_monitoring_role" {
  default = false
}

variable "create_security_group" {
  default = false
}

variable "replica_count" {
  default = 1
}

variable "deletion_protection" {
  default = true
}

variable "cloudwatch_export_logs" {
  default = ["postgresql"]
}

variable "owner" {
  type = string
}
