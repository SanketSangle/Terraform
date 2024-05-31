variable "vpc_cidr" {
  default = "192.168.0.0/16"
}

variable "project" {
  default = "cbz"
}

variable "env" {
  default = "dev"
}

variable "private_subnet_cidr" {
  default = "192.168.0.0/24"
}

variable "public_subnet_cidr" {
  default = "192.168.16.0/24"
}
