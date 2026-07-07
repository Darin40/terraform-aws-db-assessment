variable "project_name" {
  description = "Project name"
  type        = string
}

variable "environment" {
  description = "Environment name"
  type        = string
}

variable "vpc_cidr" {
  description = "CIDR block for VPC"
  type        = string
}

variable "availability_zones" {
  description = "Availability Zones"
  type        = list(string)
}

variable "public_subnet_cidrs" {
  description = "CIDRs for public subnets"
  type        = list(string)
}

variable "private_app_subnet_cidrs" {
  description = "CIDRs for private application subnets"
  type        = list(string)
}

variable "private_db_subnet_cidrs" {
  description = "CIDRs for private database subnets"
  type        = list(string)
}

variable "common_tags" {
  description = "Common resource tags"
  type        = map(string)
}