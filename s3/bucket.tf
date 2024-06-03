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
  acl    = "private"  # Set the bucket ACL to private
  force_destroy = true    # Required to delete non-empty bucket
  # Enable Object Ownership settings
  object_lock_configuration {
    object_lock_enabled = "Enabled"
    rule {
      default_retention {
        mode = "GOVERNANCE"
        days = 1
      }
    }
  }
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
