project_name = "my-application"

environment = "prod"

vpc_cidr = "10.0.0.0/16"

application_port = 8080

# 仮の値。apply前に本番環境のドメインへ置き換えること
domain_name = "my-application.example.com"

aws_region = "ap-northeast-1"

availability_zones = [
  "ap-northeast-1a",
  "ap-northeast-1c",
]
