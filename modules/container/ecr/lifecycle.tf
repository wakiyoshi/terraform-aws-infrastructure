resource "aws_ecr_lifecycle_policy" "main" {
  repository = aws_ecr_repository.main.name

  policy = jsonencode({
    rules = [
  
      {
        //ルール優先順位
        rulePriority = 1
        description  = "detele untagged images older than ${var.untagged_image_expiration_days} days"

        selection = {
          tagStatus   = "untagged"
          countType   = "sinceImagePushed"
          countUnit   = "days"
          countNumber = var.untagged_image_expiration_days
        }

        action = {
          type = "expire"
        }
      },
      {
        rulePriority = 2
        description  = "Keep only the ${ var.keep_image_count }latest tagged images"

        selection = {
          tagStatus      = "tagged"
          tagPatternList = ["*"]
          countType      = "imageCountMoreThan"
          countNumber    = var.keep_image_count
        }

        action = {
        //基本はexpireしかない
          type = "expire"
        }
      }
    ]
  })
}