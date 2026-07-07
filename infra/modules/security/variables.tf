variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_id" {
  description = "VPC ID for the security groups"
  type        = string
}

variable "alb_ingress_cidrs" {
  description = "CIDR ranges allowed to reach the ALB"
  type        = list(string)
}

variable "alb_listener_port" {
  description = "Listener port exposed by the ALB"
  type        = number
}

variable "container_port" {
  description = "Application container port"
  type        = number
}

variable "db_port" {
  description = "Database port"
  type        = number
}

variable "common_tags" {
  description = "Common tags applied to resources"
  type        = map(string)
}
