#Terraform
#optional configuration for the terraform engine
terraform {
  required_version = ">=1.0.6"
}
#provider
#implement the cloud specific API and Terraform API
#Provider configuration is specific to each privider.
#Provider expose data sources and resources to terraform
provider "aws" {
  version = "~> 2.0"
  region = "us-east-1"
}
#many providers also accept configurationvia environmental variables
#or config files. the AWS provider will reads the standard AWS CLI
#setting if they are present

#Data sources

data "aws_caller_identity" "current" {}
data "aws_availability_zones" "available" {
  state = "available"
}
#Resources




#outputs
output "aws_caller_info" {
  value = data.aws_caller_identity.current
}

#Interpolation
#substitute values in strings.
resource "aws_s3_bucket" "bucket3" {
  bucket = "${data.aws_caller_identity.current.account_id}-bucket3"
}

output "bucket_info" {
  value = aws_s3_bucket.bucket3
}

#Dependency
#resources can depend on one another, terraform will ensure that all
#dependencies are met before the resource.Dependency can be implicit or explicit.
resource "aws_s3_bucket" "bucket4" {
  bucket = "${data.aws_caller_identity.current.account_id}-bucket4"
  tags = {
   #implicit dependency
     dependency =  aws_s3_bucket.bucket3.arn
  }
}

resource "aws_s3_bucket" "bucket5" {
  bucket = "${data.aws_caller_identity.current.account_id}-bucket5"
  #Explicit
  depends_on = [
       aws_s3_bucket.bucket4
  ]
}
#variable
#can be specified on command line with -var bucket_name=my-bucket
#or in files: terraform.tfvars or *.auto.tfvars
#or in environment variables IF_VAR_bucket_name
variable "bucket_name" {
# type is an option datatype specification
  type  =  string
#default is an option default valute,if default is ommited
#default = "my_bucket"
}
resource "aws_s3_bucket" "bucket6" {
   bucket = var.bucket_name
}
#locals
#local values will assign a name to a expression. Locals can make your code more readable
locals {
  aws_account = "${data.aws_caller_identity.current.account_id}-${lower(data.aws_caller_identity.current.user_id)}"
}

resource "aws_s3_bucket" "bucket7" {
  bucket = "${local.aws_account}-bucket7"
}


#Count
#all resources hava a 'count' parameter. the default is 1
#if count is set then list of resources is returned (even if there is only 1)
#if count is set then 'count.index' value is available.this value contains the current iteration number
#TIP: setting 'count = 0' it is handy way to remove a resource+


resource "aws_s3_bucket" "bucketX" {
  count = 4
  bucket = "${local.aws_account}-bucket${count.index+7}"
}
output "bucketX"
  value = aws_s3_bucket.bucketx
}
