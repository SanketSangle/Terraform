# Configure the AWS provider
provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Define variables
variable "bucket_name" {
  description = "The name of the S3 bucket to create"
  type        = string
}

# Create S3 bucket
resource "aws_s3_bucket" "my_bucket" {
  bucket = var.bucket_name
  acl    = "public-read"  # Grant public read access to the objects in the bucket
  force_destroy = true    # Required to delete non-empty bucket
}

# Output the bucket name and website endpoint
output "bucket_name" {
  description = "The name of the S3 bucket"
  value       = aws_s3_bucket.my_bucket.bucket
}

output "bucket_website_endpoint" {
  description = "The website endpoint of the S3 bucket"
  value       = aws_s3_bucket.my_bucket.website_endpoint
}
