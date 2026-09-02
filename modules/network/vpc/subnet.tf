resource "aws_subnet" "public" {
  //count メタ引数　subnetをAZごとに作成
  count = length(var.availability_zones)

  vpc_id                  = aws_vpc.main.id
  // cidrsubnet(16.0.0.0/16, 8, 2)
  cidr_block              = cidrsubnet(var.vpc_cidr, 8, count.index)
  availability_zone       = var.availability_zones[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-public-subnet-${count.index + 1}"
      Type = "public"
    }
  )
}

resource "aws_subnet" "private" {
  count = length(var.availability_zones)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 8, count.index + length(var.availability_zones))
  availability_zone = var.availability_zones[count.index]

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-private-subnet-${count.index + 1}"
      Type = "private"
    }
  )
}
