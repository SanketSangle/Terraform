# provider "aws" {
#   region  = "us-east-1"
# }
# resource "aws_instance" "app_server" {
#   ami           = "al2023-ami-2023.4.20240528.0-kernel-6.1-x86_64"
#   instance_type = "t2.micro"
# }


# main.tf

# Define the provider
provider "aws" {
  region = "us-east-1"  # Change this to the desired AWS region
}

# Define variables for reusability
variable "instance_type" {
  description = "Type of instance to be created"
  default     = "t2.micro"
}

variable "ami_id" {
  description = "AMI ID for the instance"
  default     = "ami-00beae93a2d981137"  # Change this to the desired AMI ID
}

variable "key_name" {
  description = "Name of the SSH key pair"
  default     = "instancekey"  # Change this to your key pair name
}

variable "security_group_name" {
  description = "Name of the security group"
  default     = "sg-086a81d5be3c23969"
}

# Define the security group
# resource "aws_security_group" "instance" {
#   name        = var.security_group_name
#   description = "Allow SSH and HTTP"

  # ingress {
  #   from_port   = 22
  #   to_port     = 22
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # ingress {
  #   from_port   = 80
  #   to_port     = 80
  #   protocol    = "tcp"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }

  # egress {
  #   from_port   = 0
  #   to_port     = 0
  #   protocol    = "-1"
  #   cidr_blocks = ["0.0.0.0/0"]
  # }
# }

# Define the EC2 instance
resource "aws_instance" "web" {
  ami           = var.ami_id
  instance_type = var.instance_type
  key_name      = var.key_name
  # security_groups = [aws_security_group.instance.name]

  tags = {
    Name = "MyEC2Instance"
  }
}

# # Output the public IP of the instance
# output "instance_ip" {
#   description = "The public IP address of the EC2 instance"
#   value       = aws_instance.web.public_ip
# }
