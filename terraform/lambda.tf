resource "aws_lambda_function" "python_container" {
  function_name                  = "python-container"
  role                           = aws_iam_role.lambda_role.arn
  architectures                  = ["x86_64"]
  description                    = "Python lambda function that runs on container"
  image_uri                      = "${aws_ecr_repository.lambda-python.repository_url}:latest"
  package_type                   = "Image"
  memory_size                    = "128"
  publish                        = false
  timeout                        = 15

  ephemeral_storage {
    size = 512
  }

  depends_on = [
    aws_ecr_repository.lambda-python
  ]
}