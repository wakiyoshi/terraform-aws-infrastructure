resource "aws_internet_gateway" "main" {

  //アタッチするVPCを指定
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-igw"
    }
  )

}