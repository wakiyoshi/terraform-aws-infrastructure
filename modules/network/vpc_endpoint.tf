data "aws_region" "current" {}

# ECR API
resource "aws_vpc_endpoint" "ecr_api" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecr.api"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.vpc_endpoint.id
  ]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-ecr-api-vpce"
    }
  )
}


# ECR Docker
resource "aws_vpc_endpoint" "ecr_dkr" {
  vpc_id              = aws_vpc.main.id
  service_name        = "com.amazonaws.${data.aws_region.current.region}.ecr.dkr"
  vpc_endpoint_type   = "Interface"
  private_dns_enabled = true

  subnet_ids = aws_subnet.private[*].id

  security_group_ids = [
    aws_security_group.vpc_endpoint.id
  ]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-ecr-dkr-vpce"
    }
  )
}

# ECRのイメージレイヤーをS3から取得するためのGateway Endpoint
resource "aws_vpc_endpoint" "s3" {
  vpc_id            = aws_vpc.main.id
  service_name      = "com.amazonaws.${data.aws_region.current.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [aws_route_table.private.id]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-s3-vpce"
    }
  )
}
