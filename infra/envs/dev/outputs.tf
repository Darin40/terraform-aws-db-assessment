output "vpc_id" {
  description = "VPC ID for the dev environment"
  value       = module.network.vpc_id
}

output "alb_dns_name" {
  description = "Public DNS name of the application load balancer"
  value       = module.alb.alb_dns_name
}

output "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  value       = module.ecs.cluster_name
}

output "rds_endpoint" {
  description = "Private RDS endpoint"
  value       = module.rds.db_endpoint
}
