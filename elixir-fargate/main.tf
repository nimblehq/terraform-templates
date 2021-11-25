provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    region  = "ap-southeast-1"
    bucket  = "codewar-web-staging-terraform-state"
    key     = "codewar-web-staging/state.tfstate"
    encrypt = true
  }

  required_providers {
    aws = ">= 3.48.0"
  }
}

module "vpc" {
  source = ".././modules/vpc"

  namespace   = var.app_name
  owner       = var.owner
  environment = var.environment
}

module "security_group" {
  source = ".././modules/security_group"

  namespace                   = var.app_name
  vpc_id                      = module.vpc.vpc_id
  private_subnets_cidr_blocks = module.vpc.private_subnets_cidr_blocks
  owner                       = var.owner
  environment                 = var.environment
}

module "log" {
  source = ".././modules/log"

  namespace   = var.app_name
  owner       = var.owner
  environment = var.environment
}

module "db" {
  source = ".././modules/db"

  namespace = var.app_name

  vpc_security_group_ids = module.security_group.rds_security_group_ids
  vpc_id                 = module.vpc.vpc_id

  subnet_ids = module.vpc.private_subnet_ids

  instance_type = var.rds_instance_type
  database_name = var.rds_database_name
  username      = var.rds_username
  password      = var.rds_password
  owner         = var.owner
}

module "alb" {
  source = ".././modules/alb"

  vpc_id             = module.vpc.vpc_id
  namespace          = var.app_name
  subnets            = module.vpc.public_subnet_ids
  security_group_ids = module.security_group.alb_security_group_ids
  owner              = var.owner
}

module "ecr" {
  source = ".././modules/ecr"

  namespace = var.app_name
  owner     = var.owner
}

module "ssm" {
  source = "./modules/ssm"

  namespace         = var.app_name
  environment       = var.environment
  
  secret_key_base   = var.secret_key_base
  
  rds_username      = var.rds_username
  rds_password      = var.rds_password
  rds_endpoint      = module.db.db_instance_endpoint
  rds_database_name = var.rds_database_name
}

module "ecs" {
  source = ".././modules/ecs"

  task_definition_template      = file("task_definitions/service.json.tpl")
  subnets                       = module.vpc.private_subnet_ids
  namespace                     = var.app_name
  region                        = var.region
  app_host                      = module.alb.alb_dns_name
  app_port                      = 4000
  security_groups               = module.security_group.ecs_security_group_ids
  alb_target_group_arn          = module.alb.alb_target_group_arn
  aws_ecr_repository_url        = module.ecr.repository_url
  aws_cloudwatch_log_group_name = module.log.aws_cloudwatch_log_group_name
  desired_count                 = var.ecs_desired_count
  cpu                           = var.ecs_cpu
  memory                        = var.ecs_memory
  owner                         = var.owner
  environment                   = var.environment
  aws_parameter_store           = module.ssm.parameter_store
}
