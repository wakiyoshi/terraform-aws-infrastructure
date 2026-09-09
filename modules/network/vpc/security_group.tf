# ALB用SG
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
  description       = "Allow HTTPS from the internet"

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443
  cidr_ipv4   = "0.0.0.0/0"
}

# インターネット → ALB:80
resource "aws_vpc_security_group_ingress_rule" "alb_http" {
  security_group_id = aws_security_group.alb.id
  description       = "Allow HTTP from the internet"

  ip_protocol = "tcp"
  from_port   = 80
  to_port     = 80
  cidr_ipv4   = "0.0.0.0/0"
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

# ALB → ECS:8080
resource "aws_vpc_security_group_ingress_rule" "ecs_from_alb" {
  security_group_id = aws_security_group.ecs.id
  description       = "Allow application traffic from ALB"

  ip_protocol = "tcp"
  from_port   = 8080
  to_port     = 8080

  //予約変数：albのingressを通った通信のみ許可
  referenced_security_group_id = aws_security_group.alb.id
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
resource "aws_vpc_security_group_ingress_rule" "rds_from_ecs" {
  security_group_id = aws_security_group.rds.id
  description       = "Allow MySQL connections from ECS"

  ip_protocol = "tcp"
  from_port   = 3306
  to_port     = 3306

  //ecsからの通信のみ許可するため
  referenced_security_group_id = aws_security_group.ecs.id
}

# Interface型VPC Endpoint用SG
resource "aws_security_group" "vpc_endpoint" {
  name        = "${var.project_name}-${var.environment}-vpc-endpoint-sg"
  description = "Security group for interface VPC endpoints"
  vpc_id      = aws_vpc.main.id

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-vpc-endpoint-sg"
  })
}

# ECSタスクからInterface型VPC EndpointへのHTTPS通信
resource "aws_vpc_security_group_ingress_rule" "vpc_endpoint_https_from_ecs" {
  security_group_id = aws_security_group.vpc_endpoint.id
  description       = "Allow HTTPS from ECS tasks"

  ip_protocol = "tcp"
  from_port   = 443
  to_port     = 443

  referenced_security_group_id = aws_security_group.ecs.id
}

