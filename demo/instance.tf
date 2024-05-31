provider "aws" {
  region  = "us-east-1"
}
resource "aws_instance" "app_server" {
  ami           = "al2023-ami-2023.4.20240528.0-kernel-6.1-x86_64"
  instance_type = "t2.micro"
}