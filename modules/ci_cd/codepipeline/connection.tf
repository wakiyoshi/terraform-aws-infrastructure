resource "aws_codestarconnections_connection" "github" {
  name          = "${var.project_name}-${var.environment}-github"
  provider_type = "GitHub"

  tags = var.common_tags
}
