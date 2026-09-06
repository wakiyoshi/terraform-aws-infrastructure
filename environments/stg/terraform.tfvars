project_name = "grant-application"
environment  = "stg"
aws_region   = "ap-northeast-1"
vpc_cidr     = "10.1.0.0/16"

availability_zones = [
  "ap-northeast-1a",
  "ap-northeast-1c",
]

application_port = 8080
domain_name      = "stg.grant-application.example.com"
