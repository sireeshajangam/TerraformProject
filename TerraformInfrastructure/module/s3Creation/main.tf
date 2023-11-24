provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "mybucket" {
  bucket = "TerraformStatefileConfiguration33"
  # Other bucket configurations...
}

