variable "namespace" {
  type = string
}

variable "vpc_id" {
  description = "VPC ID"
}

variable "private_subnets_cidr_blocks" {
  description = "Private subnet CIDR blocks"
}

variable "environment" {
  type = string
}

variable "owner" {
  type = string
}
