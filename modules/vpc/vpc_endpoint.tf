data "aws_region" "current" {}

# S3 Gateway Endpointは無料でNATのデータ処理料金も抑えられるため維持する
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
