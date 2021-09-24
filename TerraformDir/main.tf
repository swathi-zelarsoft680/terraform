provider "aws" {
region = "us-east-1"
version = "~> 2.0"
}

resource "aws_s3_bucket" "MyBucket" {
  bucket = "binnubucket"
}
