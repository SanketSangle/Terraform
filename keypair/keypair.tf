# Specify the Terraform version
terraform {
  required_version = ">= 0.12"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = ">= 3.0"
    }
  }
}

# Configure the AWS provider
provider "aws" {
  region = "us-east-1" # Specify your preferred region
}

# Create a key pair
resource "aws_key_pair" "ec2_key_pair" {
  key_name   = "my-ec2-key-pair"
  public_key = file("C:\Users\Admin\.ssh/id_rsa.pub") # Path to your existing public key file
}

# Create an EC2 instance
# resource "aws_instance" "my_ec2_instance" {
#   ami           = "ami-0c55b159cbfafe1f0" # Replace with your preferred AMI ID
#   instance_type = "t2.micro"
#   key_name      = aws_key_pair.ec2_key_pair.key_name

#   tags = {
#     Name = "my-ec2-instance"
#   }
# }

# Output the instance ID and public IP
# s