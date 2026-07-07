variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the target group"
  type        = string
}

variable "subnet_ids" {
  description = "Public subnet IDs for the ALB"
  type        = list(string)
}

variable "security_group_id" {
  description = "Security group ID attached to the ALB"
  type        = string
}

variable "listener_port" {
  description = "Port exposed by the ALB listener"
  type        = number
}

variable "target_port" {
  description = "Container port registered in the target group"
  type        = number
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
}
