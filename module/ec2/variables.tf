# Define variables for ec2 module inputs

variable "this_aws_instance_ami" {
  description = "The AMI ID to use for launching the EC2 instance"
  type = string
}

variable "this_aws_instance_instance_type" {
  description = "The type of EC2 instance (e.g., t2.micro, m5.xlarge)"
  type = string
}

variable "this_aws_instance_key_name" {
  description = "The name of the SSH key pair used to access the instance"
  type = string
}

variable "this_aws_instance_availability_zone" {
  description = "The Availability Zone within the region to launch the instance"
  type = string
}

variable "this_aws_instance_volume_size" {
  description = "The size (in GiB) of the root volume for the instance"
  type = number
}

variable "this_aws_instance_count" {
  description = "The number of EC2 instances to launch (default 1)"
  type = number
  default = 1
}

variable "this_aws_instance_user_data_base64" {
  description = "Set to true to enable user data script (consider security implications)"
  type = bool
  default = false
}

variable "this_aws_instance_tags" {
  description = "A map of tags to assign to the EC2 instance (e.g., Name: my-instance)"
  type = map(string)
}