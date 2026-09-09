project_name = "grant-application"
environment  = "prod"
aws_region   = "ap-northeast-1"
vpc_cidr     = "10.0.0.0/16"

availability_zones = [
  "ap-northeast-1a",
  "ap-northeast-1c",
]

application_port = 8080
domain_name      = ".prod.waki-cloud-lab.com"

//コストがかかるサービスのon/off切り替え
enable_paid_resources = false
