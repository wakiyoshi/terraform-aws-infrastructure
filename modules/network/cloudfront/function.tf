resource "aws_cloudfront_function" "spa_rewrite" {
  name    = "${var.project_name}-${var.environment}-spa-rewrite"
  runtime = "cloudfront-js-2.0"
  comment = "Rewrite SPA screen paths to index.html"
  publish = true
  code    = file("${path.module}/spa-rewrite.js")
}
