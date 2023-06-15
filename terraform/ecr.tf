resource "aws_ecr_repository" "lambda-python" {
  name                 = "lambda-python"
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}