variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region for the deployment"
  type        = string
}

variable "vpc_cidr" {
  description = "VPC CIDR block"
  type        = string
}

variable "availability_zones" {
  description = "Availability zones used by the environment"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "Public subnet CIDR blocks"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "Private application subnet CIDR blocks"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "Private database subnet CIDR blocks"
  type        = list(string)
}

variable "alb_ingress_cidrs" {
  description = "CIDR blocks allowed to reach the ALB"
  type        = list(string)
}

variable "alb_listener_port" {
  description = "ALB listener port"
  type        = number
}

variable "container_name" {
  description = "Container name"
  type        = string
}

variable "container_image" {
  description = "Container image"
  type        = string
}

variable "container_port" {
  description = "Container port"
  type        = number
}

variable "ecs_desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
}

variable "ecs_task_cpu" {
  description = "Fargate CPU units"
  type        = string
}

variable "ecs_task_memory" {
  description = "Fargate memory in MiB"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log retention in days"
  type        = number
}

variable "db_engine" {
  description = "RDS engine"
  type        = string
}

variable "db_engine_version" {
  description = "RDS engine version"
  type        = string
}

variable "db_instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "db_allocated_storage" {
  description = "Initial RDS storage allocation"
  type        = number
}

variable "db_max_allocated_storage" {
  description = "Maximum RDS autoscaled storage"
  type        = number
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "db_username" {
  description = "RDS master username"
  type        = string
}

variable "db_password" {
  description = "RDS master password"
  type        = string
  sensitive   = true
}

variable "db_port" {
  description = "RDS port"
  type        = number
}

variable "db_multi_az" {
  description = "Whether RDS runs in Multi-AZ mode"
  type        = bool
}

variable "db_backup_retention_period" {
  description = "Backup retention period in days"
  type        = number
}

variable "db_deletion_protection" {
  description = "Whether deletion protection is enabled"
  type        = bool
}

variable "db_skip_final_snapshot" {
  description = "Whether to skip the final snapshot on deletion"
  type        = bool
}
