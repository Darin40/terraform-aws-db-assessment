locals {
  common_tags = {
    Project     = var.project_name
    Environment = var.environment
    ManagedBy   = "Terraform"
    Repository  = "terraform-aws-db-assessment"
  }
}

module "network" {
  source = "../../modules/network"

  project_name             = var.project_name
  environment              = var.environment
  vpc_cidr                 = var.vpc_cidr
  availability_zones       = var.availability_zones
  public_subnet_cidrs      = var.public_subnet_cidrs
  private_app_subnet_cidrs = var.private_app_subnet_cidrs
  private_db_subnet_cidrs  = var.private_db_subnet_cidrs
  common_tags              = local.common_tags
}

module "security" {
  source = "../../modules/security"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.network.vpc_id
  alb_ingress_cidrs = var.alb_ingress_cidrs
  alb_listener_port = var.alb_listener_port
  container_port    = var.container_port
  db_port           = var.db_port
  common_tags       = local.common_tags
}

module "alb" {
  source = "../../modules/alb"

  project_name      = var.project_name
  environment       = var.environment
  vpc_id            = module.network.vpc_id
  subnet_ids        = module.network.public_subnet_ids
  security_group_id = module.security.alb_security_group_id
  listener_port     = var.alb_listener_port
  target_port       = var.container_port
  common_tags       = local.common_tags
}

module "rds" {
  source = "../../modules/rds"

  project_name            = var.project_name
  environment             = var.environment
  subnet_ids              = module.network.private_db_subnet_ids
  security_group_ids      = [module.security.rds_security_group_id]
  db_engine               = var.db_engine
  db_engine_version       = var.db_engine_version
  instance_class          = var.db_instance_class
  allocated_storage       = var.db_allocated_storage
  max_allocated_storage   = var.db_max_allocated_storage
  db_name                 = var.db_name
  username                = var.db_username
  password                = var.db_password
  port                    = var.db_port
  multi_az                = var.db_multi_az
  backup_retention_period = var.db_backup_retention_period
  deletion_protection     = var.db_deletion_protection
  skip_final_snapshot     = var.db_skip_final_snapshot
  common_tags             = local.common_tags
}

module "ecs" {
  source = "../../modules/ecs"

  project_name       = var.project_name
  environment        = var.environment
  aws_region         = var.aws_region
  subnet_ids         = module.network.private_app_subnet_ids
  security_group_id  = module.security.ecs_security_group_id
  target_group_arn   = module.alb.target_group_arn
  container_name     = var.container_name
  container_image    = var.container_image
  container_port     = var.container_port
  desired_count      = var.ecs_desired_count
  task_cpu           = var.ecs_task_cpu
  task_memory        = var.ecs_task_memory
  log_retention_days = var.log_retention_days
  common_tags        = local.common_tags
}
