variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "aws_region" {
  description = "AWS region used by the ECS task logs"
  type        = string
}

variable "subnet_ids" {
  description = "Private application subnet IDs"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID for ECS tasks"
  type        = string
}

variable "target_group_arn" {
  description = "ALB target group ARN"
  type        = string
}

variable "container_name" {
  description = "Container name used in the task definition"
  type        = string
}

variable "container_image" {
  description = "Container image deployed on ECS"
  type        = string
}

variable "container_port" {
  description = "Application container port"
  type        = number
}

variable "desired_count" {
  description = "Desired number of ECS tasks"
  type        = number
}

variable "task_cpu" {
  description = "CPU units for the Fargate task"
  type        = string
}

variable "task_memory" {
  description = "Memory in MiB for the Fargate task"
  type        = string
}

variable "log_retention_days" {
  description = "CloudWatch log retention"
  type        = number
}

variable "assign_public_ip" {
  description = "Whether the tasks should receive a public IP"
  type        = bool
  default     = false
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
}
