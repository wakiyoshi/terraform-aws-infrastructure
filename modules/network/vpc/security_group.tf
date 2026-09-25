# ALB用SG
data "aws_ec2_managed_prefix_list" "cloudfront_origin_facing" {
  count = var.environment == "prod" ? 1 : 0
  name  = "com.amazonaws.global.cloudfront.origin-facing"
}

resource "aws_security_group" "alb" {
  name        = "${var.project_name}-${var.environment}-alb-sg"
  description = "Security group for public ALB"
  vpc_id      = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-alb-sg"
  })
}

# インターネット → ALB:443
resource "aws_vpc_security_group_ingress_rule" "alb_https" {
  security_group_id = aws_security_group.alb.id
  description       = var.environment == "prod" ? "Allow HTTPS from CloudFront" : "Allow HTTPS from the internet"

  ip_protocol    = "tcp"
  from_port      = 443
  to_port        = 443
  cidr_ipv4      = var.environment == "prod" ? null : "0.0.0.0/0"
  prefix_list_id = var.environment == "prod" ? data.aws_ec2_managed_prefix_list.cloudfront_origin_facing[0].id : null
}

# インターネット → ALB:80
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  count = var.environment == "prod" ? 0 : 1

  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP from the internet"

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_ipv4   = "0.0.0.0/0"
}

# ALB → ECS:アプリケーションポート
resource "aws_vpc_security_group_egress_rule" "alb_to_ecs" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow application traffic to ECS tasks"

  ip_protocol                  = "tcp"
  from_port                    = var.application_port
  to_port                      = var.application_port
  referenced_security_group_id = aws_security_group.ecs.id
}

# ECS用SG
resource "aws_security_group" "ecs" {
  name        = "${var.project_name}-${var.environment}-ecs-sg"
  description = "Security group for ECS tasks"
  vpc_id      = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-ecs-sg"
  })
}

# ALB → ECS:アプリケーションポート
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow application traffic from ALB"

  ip_protocol = "tcp"
  from_port   = var.application_port
  to_port     = var.application_port

  //予約変数：albのingressを通った通信のみ許可
  referenced_security_group_id = aws_security_group.alb.id
}

# ECS → NAT Gateway経由のHTTPS通信
resource "aws_vpc_security_group_egress_rule" "ecs_https" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow HTTPS through the NAT gateway"

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_ipv4   = "0.0.0.0/0"
}

# RDS用SG
resource "aws_security_group" "rds" {
  name        = "${var.project_name}-${var.environment}-rds-sg"
  description = "Security group for RDS"
  vpc_id      = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-rds-sg"
  })
}

# ECS → RDS:3306
resource "aws_vpc_security_group_egress_rule" "ecs_to_rds" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow MySQL connections to RDS"

  ip_protocol                  = "tcp"
  from_port                    = 3306
  to_port                      = 3306
  referenced_security_group_id = aws_security_group.rds.id
}

# ECS → RDS:3306
resource "aws_vpc_security_group_ingress_rule" "rds_from_ecs" {
  security_group_id = aws_security_group.rds.id
  description       = "Allow MySQL connections from ECS"

  ip_protocol = "tcp"
  from_port   = 3306
  to_port     = 3306

  //ecsからの通信のみ許可するため
  referenced_security_group_id = aws_security_group.ecs.id
}
