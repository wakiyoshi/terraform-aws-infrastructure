resource "aws_route53_zone" "main" {
  name = var.domain_name

  tags = merge(
    var.common_tags,
    {
      Name = "${var.project_name}-${var.environment}-public-zone"
    }
  )
}
