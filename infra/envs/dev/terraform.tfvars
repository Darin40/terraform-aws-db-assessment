project_name = "hotel-platform"
environment  = "dev"
aws_region   = "us-east-1"

vpc_cidr = "10.10.0.0/16"

availability_zones = [
  "us-east-1a",
  "us-east-1b",
]

public_subnet_cidrs = [
  "10.10.1.0/24",
  "10.10.2.0/24",
]

private_app_subnet_cidrs = [
  "10.10.11.0/24",
  "10.10.12.0/24",
]

private_db_subnet_cidrs = [
  "10.10.21.0/24",
  "10.10.22.0/24",
]

alb_ingress_cidrs = ["0.0.0.0/0"]
alb_listener_port = 80

container_name  = "nginx"
container_image = "nginx:1.27-alpine"
container_port  = 80

ecs_desired_count = 1
ecs_task_cpu      = "256"
ecs_task_memory   = "512"

log_retention_days = 7

db_engine                  = "postgres"
db_engine_version          = "16.3"
db_instance_class          = "db.t3.micro"
db_allocated_storage       = 20
db_max_allocated_storage   = 100
db_name                    = "hotelapp"
db_username                = "appadmin"
db_password                = "Assessment123!"
db_port                    = 5432
db_multi_az                = false
db_backup_retention_period = 3
db_deletion_protection     = false
db_skip_final_snapshot     = true
