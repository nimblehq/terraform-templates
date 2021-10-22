variable "namespace" {
  type = string
}

variable "log_retention_in_days" {
  description = "How long (days) to retain the log data"
  default     = 14
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}
