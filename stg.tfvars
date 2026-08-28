project_name = "grant-application"

environment = "stg"

vpc_cidr = "10.2.0.0/16"

application_port = 8080

# 仮の値。apply前にステージング環境のドメインへ置き換えること
domain_name = "stg.grant-application.example.com"

aws_region = "ap-northeast-1"

availability_zones = [
  "ap-northeast-1a",
  "ap-northeast-1c",
]
