resource "aws_rds_cluster" "main" {
  cluster_identifier = "${var.project_name}-${var.environment}-aurora"

  engine         = "aurora-mysql"
  engine_mode    = "provisioned"
  engine_version = var.engine_version

  database_name   = var.database_name
  master_username = var.master_username

  manage_master_user_password   = true
  master_user_secret_kms_key_id = var.master_user_secret_kms_key_id
  storage_encrypted             = true

  db_subnet_group_name            = aws_db_subnet_group.main.name
  vpc_security_group_ids          = [var.rds_security_group_id]
  db_cluster_parameter_group_name = aws_rds_cluster_parameter_group.main.name

  serverlessv2_scaling_configuration {
    min_capacity = var.serverless_min_capacity
    max_capacity = var.serverless_max_capacity
  }

  backup_retention_period      = var.backup_retention_period
  preferred_backup_window      = var.preferred_backup_window
  preferred_maintenance_window = var.preferred_maintenance_window
  copy_tags_to_snapshot        = true

  enabled_cloudwatch_logs_exports = [
    "error",
    "slowquery",
  ]

  deletion_protection = var.deletion_protection
  skip_final_snapshot = var.skip_final_snapshot
  final_snapshot_identifier = var.skip_final_snapshot ? null : (
    "${var.project_name}-${var.environment}-aurora-final"
  )
  apply_immediately = var.apply_immediately

  iam_database_authentication_enabled = var.iam_database_authentication_enabled

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-aurora"
  })
}
