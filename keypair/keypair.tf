provider "aws" {
  region = "us-east-1"  # Replace with your desired region
}

# Variables
variable "key_name" {
  description = "The name of the SSH key pair to create"
  type        = string
}

variable "bucket_name" {
  description = "The name of the existing S3 bucket where the key will be stored"
  type        = string
  default = "ec2-resource-tf"
}

# Create SSH key pair
resource "tls_private_key" "example" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "generated_key" {
  key_name   = var.key_name
  public_key = tls_private_key.example.public_key_openssh
}

# Store private key in S3 bucket
resource "aws_s3_bucket_object" "private_key" {
  bucket = var.bucket_name
  key    = "${var.key_name}_private_key.pem"
  content = tls_private_key.example.private_key_pem
  acl    = "private"
}

# Output the key name and location in S3 (optional, for verification)
output "key_name" {
  description = "The name of the SSH key pair"
  value       = aws_key_pair.generated_key.key_name
}

# output "private_key_s3_path" {
#   description = "The S3 path to the private key"
#   value       = "s3://${var.bucket_name}/${var.key_name}_private_key.pem"
# }
