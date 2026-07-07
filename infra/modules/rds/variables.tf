variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "subnet_ids" {
  description = "Private database subnet IDs"
  type        = list(string)
}

variable "security_group_ids" {
  description = "Security group IDs attached to the DB instance"
  type        = list(string)
}

variable "db_engine" {
  description = "Database engine"
  type        = string
}

variable "db_engine_version" {
  description = "Database engine version"
  type        = string
}

variable "instance_class" {
  description = "RDS instance class"
  type        = string
}

variable "allocated_storage" {
  description = "Initial storage allocation in GiB"
  type        = number
}

variable "max_allocated_storage" {
  description = "Maximum autoscaled storage in GiB"
  type        = number
}

variable "db_name" {
  description = "Initial database name"
  type        = string
}

variable "username" {
  description = "Master username"
  type        = string
}

variable "password" {
  description = "Master password"
  type        = string
  sensitive   = true
}

variable "port" {
  description = "Database port"
  type        = number
}

variable "multi_az" {
  description = "Whether to enable Multi-AZ deployment"
  type        = bool
}

variable "backup_retention_period" {
  description = "RDS backup retention period in days"
  type        = number
}

variable "deletion_protection" {
  description = "Whether deletion protection is enabled"
  type        = bool
}

variable "skip_final_snapshot" {
  description = "Whether to skip the final snapshot on deletion"
  type        = bool
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
}
