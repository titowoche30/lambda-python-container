terraform {
  backend "s3" {
    bucket         = "cwoche-tf-state"
    key            = "terraform-states/lambda-python-container/terraform.tfstate"
    region         = "us-east-1"
  }
}
