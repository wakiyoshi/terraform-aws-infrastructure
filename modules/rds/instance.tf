resource "aws_rds_cluster_instance" "main" {
  count = var.instance_count

  identifier         = "${var.project_name}-${var.environment}-aurora-${count.index + 1}"
  cluster_identifier = aws_rds_cluster.main.id

  engine         = aws_rds_cluster.main.engine
  engine_version = aws_rds_cluster.main.engine_version
  instance_class = "db.serverless"

  db_parameter_group_name = aws_db_parameter_group.main.name
  db_subnet_group_name    = aws_db_subnet_group.main.name

  auto_minor_version_upgrade = true
  publicly_accessible        = false
  apply_immediately          = var.apply_immediately

  performance_insights_enabled          = var.performance_insights_enabled
  performance_insights_retention_period = var.performance_insights_enabled ? 7 : null

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-aurora-${count.index + 1}"
  })
}
