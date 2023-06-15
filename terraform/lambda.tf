resource "aws_lambda_function" "python_container" {
  function_name                  = "python-container"
  role                           = aws_iam_role.lambda_role.arn
  architectures                  = ["x86_64"]
  description                    = "Python lambda function that runs on container"
  ephemeral_storage              = "512"
  image_uri                      = ""
  package_type                   = "Image"
  memory_size                    = "128"
  publish                        = false
  reserved_concurrent_executions = 1
  timeout                        = 15
  vpc_config {
    security_group_ids = ["sg-0d544fa0f498342a4"]
    subnet_ids         = ["subnet-0f729848d7bc48e2c"]
  }

  depends_on = [
    aws_iam_role.lambda_role,
    aws_ecr_repository.lambda-python
  ]
}