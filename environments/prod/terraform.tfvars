project_name = "grant-application"
environment  = "prod"
aws_region   = "ap-northeast-1"
vpc_cidr     = "10.0.0.0/16"

availability_zones = [
  "ap-northeast-1a",
  "ap-northeast-1c",
]

application_port = 8080
domain_name      = "prod.waki-cloud-lab.com"

//コストがかかるサービスのon/off切り替え
enable_paid_resources = false

keep_image_count               = 20
untagged_image_expiration_days = 14
ssl_policy                     = "ELBSecurityPolicy-TLS13-1-2-Res-PQ-2025-09"
health_check_path              = "/health"
image_tag                      = "latest"
container_name                 = "app"
task_cpu                       = 1024
task_memory                    = 2048
desired_count                  = 2
autoscaling_min_capacity       = 2
autoscaling_max_capacity       = 6
autoscaling_cpu_target         = 60
log_retention_days             = 30
container_environment          = {}
