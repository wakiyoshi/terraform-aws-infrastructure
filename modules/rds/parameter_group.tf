resource "aws_rds_cluster_parameter_group" "main" {
  name        = "${var.project_name}-${var.environment}-aurora-mysql-cluster"
  family      = "aurora-mysql8.0"
  description = "Aurora MySQL cluster parameters for ${var.project_name}-${var.environment}"

  parameter {
    name  = "character_set_server"
    value = "utf8mb4"
  }

  parameter {
    name  = "collation_server"
    value = "utf8mb4_0900_ai_ci"
  }

  parameter {
    name  = "time_zone"
    value = "Asia/Tokyo"
  }

  parameter {
    name  = "slow_query_log"
    value = "1"
  }

  parameter {
    name  = "log_output"
    value = "FILE"
  }

  parameter {
    name  = "long_query_time"
    value = "2"
  }

  parameter {
    name  = "server_audit_logging"
    value = "1"
  }

  parameter {
    name  = "server_audit_events"
    value = "CONNECT,QUERY_DDL,QUERY_DCL"
  }

  tags = var.common_tags
}

resource "aws_db_parameter_group" "main" {
  name        = "${var.project_name}-${var.environment}-aurora-mysql-instance"
  family      = "aurora-mysql8.0"
  description = "Aurora MySQL instance parameters for ${var.project_name}-${var.environment}"

  tags = var.common_tags
}
