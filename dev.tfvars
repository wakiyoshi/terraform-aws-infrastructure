project_name = "grant-application"

environment = "dev"

vpc_cidr = "10.2.0.0/16"

application_port = 8080

# 仮の値。apply前に開発環境のドメインへ置き換えること
domain_name = "dev.grant-application.example.com"

aws_region = "ap-northeast-1"

availability_zones = [
  "ap-northeast-1a",
  "ap-northeast-1c",
]
