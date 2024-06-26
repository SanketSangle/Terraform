# # Output the access key ID and secret access key
# output "admin_access_key_id" {
#   value = aws_iam_access_key.admin.id
# }

# output "admin_secret_access_key" {
#   value     = aws_iam_access_key.admin.secret
#   sensitive = true
# }

# Specify the Terraform version
terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
  backend "s3" {
    bucket = "iam-resource-tf"
    key    = "terraform.tfstate"
    region = "us-east-1"
  }
}

# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Specify your preferred region
}

# Create an IAM user named "admin"
resource "aws_iam_user" "admin_user" {
  name = "admin"

  tags = {
    "Name" = "admin"
  }
}

# Attach the AdministratorAccess policy to the IAM user
resource "aws_iam_user_policy_attachment" "admin_user_policy" {
  user       = aws_iam_user.admin_user.name
  policy_arn = "arn:aws:iam::aws:policy/AdministratorAccess"
}

# Create access keys for the IAM user
resource "aws_iam_access_key" "admin_user_key" {
  user = aws_iam_user.admin_user.name
}

# Store access keys in an S3 bucket
resource "aws_s3_bucket_object" "admin_user_key" {
  bucket = "iam-resource-tf" # Replace with your existing bucket name
  key    = "admin_user_credentials.json"
  content = jsonencode({
    access_key_id     = aws_iam_access_key.admin_user_key.id
    secret_access_key = aws_iam_access_key.admin_user_key.secret
  })
}

# Output the S3 object URL
output "s3_object_url" {
  value = aws_s3_bucket_object.admin_user_key.id
}

# Output the S3 object URL
# output "s3_object_url" {
#   value = "s3://${aws_s3_object.admin_user_key.bucket}/${aws_s3_object.admin_user_key.key}"
# }
