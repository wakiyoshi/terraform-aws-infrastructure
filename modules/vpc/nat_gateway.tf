# 各AZのPublic SubnetにNAT Gatewayを配置する
resource "aws_eip" "nat" {
  count  = var.enable_paid_resources ? length(var.availability_zones) : 0
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-nat-eip-${count.index + 1}"
  })
}

resource "aws_nat_gateway" "main" {
  count = var.enable_paid_resources ? length(var.availability_zones) : 0

  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  depends_on = [aws_internet_gateway.main]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-nat-${count.index + 1}"
  })
}
