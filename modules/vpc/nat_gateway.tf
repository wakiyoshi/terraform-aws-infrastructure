# Private Subnetの外向き通信を集約する単一NAT Gateway
# コストを抑える構成のため、AZ障害時の冗長性は持たない
resource "aws_eip" "nat" {
  count  = var.enable_paid_resources ? 1 : 0
  domain = "vpc"

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-nat-eip"
  })
}

resource "aws_nat_gateway" "main" {
  count = var.enable_paid_resources ? 1 : 0

  allocation_id = aws_eip.nat[0].id
  subnet_id     = aws_subnet.public[0].id

  depends_on = [aws_internet_gateway.main]

  tags = merge(var.common_tags, {
    Name = "${var.project_name}-${var.environment}-nat"
  })
}
