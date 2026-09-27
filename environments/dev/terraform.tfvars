project_name = "grant-application"
environment  = "dev"
aws_region   = "ap-northeast-1"
vpc_cidr     = "10.2.0.0/16"

availability_zones = [
  "ap-northeast-1a",
  "ap-northeast-1c",
]

application_port = 8080
domain_name      = "dev.waki-cloud-lab.com"

//コストがかかるサービスのon/off切り替え
enable_paid_resources = false

//　ecr ecs
keep_image_count               = 5
untagged_image_expiration_days = 3
ssl_policy                     = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
health_check_path              = "/health"
# 初回ECS作成前に、アプリ側WorkflowがECRへpushしたGit commit SHAへ変更する
bootstrap_image_tag      = "latest"
container_name           = "app"
task_cpu                 = 256
task_memory              = 512
desired_count            = 1
autoscaling_min_capacity = 1
autoscaling_max_capacity = 2
autoscaling_cpu_target   = 70
log_retention_days       = 7
container_environment    = {}

// Aurora Serverless v2
database_name                  = "app"
database_master_username       = "dbadmin"
aurora_engine_version          = "8.0.mysql_aurora.3.08.2"
rds_instance_count             = 1
aurora_serverless_min_capacity = 1
aurora_serverless_max_capacity = 2
rds_backup_retention_period    = 1
rds_deletion_protection        = false
rds_skip_final_snapshot        = true

cloudwatch_alarm_email_addresses = ["wakk12107@gmail.com"]
