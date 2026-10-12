project_name = "grant-application"
environment  = "prod"
aws_region   = "ap-northeast-1"
vpc_cidr     = "10.0.0.0/16"

availability_zones = [
  "ap-northeast-1a",
  "ap-northeast-1c",
]

application_port = 8080
domain_name      = "waki-cloud-lab.com"

//コストがかかるサービスのon/off切り替え
enable_paid_resources = false

keep_image_count               = 20
untagged_image_expiration_days = 14
ssl_policy                     = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
health_check_path              = "/health"
container_name                 = "app"
task_cpu                       = 1024
task_memory                    = 2048
desired_count                  = 2
autoscaling_min_capacity       = 2
autoscaling_max_capacity       = 6
autoscaling_cpu_target         = 60
log_retention_days             = 30
container_environment          = {}

// Aurora Serverless v2
database_name                  = "app"
database_master_username       = "dbadmin"
aurora_engine_version          = "8.0.mysql_aurora.3.08.2"
rds_instance_count             = 2
aurora_serverless_min_capacity = 2
aurora_serverless_max_capacity = 16
rds_backup_retention_period    = 14
rds_deletion_protection        = true
rds_skip_final_snapshot        = false

cloudwatch_alarm_email_addresses = ["wakk12107@gmail.com"]

# DEV public hosted zone name servers
delegated_name_servers = {
  dev = [
    "ns-1322.awsdns-37.org",
    "ns-1774.awsdns-29.co.uk",
    "ns-314.awsdns-39.com",
    "ns-693.awsdns-22.net",
  ]
}
