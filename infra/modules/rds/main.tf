resource "aws_db_subnet_group" "this" {
  name       = "${var.project_name}-${var.environment}-db-subnets"
  subnet_ids = var.subnet_ids

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-db-subnet-group"
    }
  )
}

resource "aws_db_instance" "this" {
  identifier                 = "${var.project_name}-${var.environment}-db"
  engine                     = var.db_engine
  engine_version             = var.db_engine_version
  instance_class             = var.instance_class
  allocated_storage          = var.allocated_storage
  max_allocated_storage      = var.max_allocated_storage
  storage_type               = "gp3"
  storage_encrypted          = true
  db_name                    = var.db_name
  username                   = var.username
  password                   = var.password
  port                       = var.port
  multi_az                   = var.multi_az
  publicly_accessible        = false
  db_subnet_group_name       = aws_db_subnet_group.this.name
  vpc_security_group_ids     = var.security_group_ids
  backup_retention_period    = var.backup_retention_period
  deletion_protection        = var.deletion_protection
  skip_final_snapshot        = var.skip_final_snapshot
  final_snapshot_identifier  = var.skip_final_snapshot ? null : "${var.project_name}-${var.environment}-final-snapshot"
  auto_minor_version_upgrade = true
  apply_immediately          = true

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-db"
    }
  )
}
