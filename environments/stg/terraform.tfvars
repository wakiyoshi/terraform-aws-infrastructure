project_name = "grant-application"
environment  = "stg"
aws_region   = "ap-northeast-1"
vpc_cidr     = "10.1.0.0/16"

availability_zones = [
  "ap-northeast-1a",
  "ap-northeast-1c",
]

application_port = 8080
domain_name      = "stg.waki-cloud-lab.com"

//コストがかかるサービスのon/off切り替え
enable_paid_resources = false

keep_image_count               = 10
untagged_image_expiration_days = 7
ssl_policy                     = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
health_check_path              = "/health"
image_tag                      = "latest"
container_name                 = "app"
task_cpu                       = 512
task_memory                    = 1024
desired_count                  = 1
autoscaling_min_capacity       = 1
autoscaling_max_capacity       = 3
autoscaling_cpu_target         = 65
log_retention_days             = 14
container_environment          = {}

// Aurora Serverless v2
database_name                  = "app"
database_master_username       = "dbadmin"
aurora_engine_version          = "8.0.mysql_aurora.3.08.2"
rds_instance_count             = 1
aurora_serverless_min_capacity = 1
aurora_serverless_max_capacity = 2
rds_backup_retention_period    = 7
rds_deletion_protection        = false
rds_skip_final_snapshot        = false
