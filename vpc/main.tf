# resource "aws_vpc" "this_vpc" {
#   cidr_block = var.this_vpc_cidr_block // "12.11.0.0/16"
#   tags = {
#     Name = var.this_vpc_tags // "this_vpc"
#   }
# }

# resource "aws_subnet" "this_subnet_pub" {
#   vpc_id                  = aws_vpc.this_vpc.id  
#   availability_zone       = "us-east-1a"
#   cidr_block              = var.this_subnet_pub_cidr_block // "12.11.0.0/17"
#   map_public_ip_on_launch = var.this_subnet_pub_map_ip // true
#   tags = {
#     Name = var.this_subnet_pub_tags // "pub_subnet"
#   }
# }

# resource "aws_subnet" "this_subnet_private1" {
#   vpc_id                  = aws_vpc.this_vpc.id
#   availability_zone       = "us-east-1a"
#   cidr_block              = var.this_subnet_private1_cidr_block // "12.11.128.0/19"
#   map_public_ip_on_launch = var.this_subnet_private_map_ip // false
#   tags = {
#     Name = var.this_subnet_private1_tags // "pri_subnet1"
#   }
# }

# resource "aws_subnet" "this_subnet_private2" {
#   vpc_id                  = aws_vpc.this_vpc.id
#   availability_zone       = "us-east-1a"
#   cidr_block              = var.this_subnet_private2_cidr_block // "12.11.192.0/20"
#   map_public_ip_on_launch = var.this_subnet_private_map_ip // false
#   tags = {
#     Name = var.this_subnet_private2_tags // "pri_subnet2"
#   }
# }

# resource "aws_internet_gateway" "this_igw" {
#   vpc_id = aws_vpc.this_vpc.id
#   tags = {
#     Name = var.this_igw_tags
#   }
# }

# resource "aws_route_table" "this_route_table" {
#   vpc_id = aws_vpc.this_vpc.id

#   route {
#     cidr_block = var.this_def_Route_example_cidr_block // "0.0.0.0/0"
#     gateway_id = aws_internet_gateway.this_igw.id
#   }

#   tags = {
#     Name = var.this_def_Route_example_tag // "default"
#   }
# }

# resource "aws_route_table_association" "this_rw_association" {
#   subnet_id      = aws_subnet.this_subnet_pub.id
#   route_table_id = aws_route_table.this_route_table.id
# }


provider "aws" {
  region = "us-east-1"  # Change this to your desired region
}

# Create a VPC
resource "aws_vpc" "main_vpc" {
  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true
  tags = {
    Name = "main_vpc"
  }
}

# Create Subnets
resource "aws_subnet" "public_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.1.0/24"
  map_public_ip_on_launch = true
  availability_zone = "us-east-1a"  # Change to your desired AZ
  tags = {
    Name = "public_subnet"
  }
}

resource "aws_subnet" "private_subnet" {
  vpc_id            = aws_vpc.main_vpc.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "us-east-1b"  # Change to your desired AZ
  tags = {
    Name = "private_subnet"
  }
}

# Create Internet Gateway
resource "aws_internet_gateway" "main_igw" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "main_igw"
  }
}

# Create Route Table for Public Subnet
resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "public_rt"
  }
}

# Associate Route Table with Subnet
resource "aws_route_table_association" "public_rt_assoc" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}

# Create a Route to the Internet
resource "aws_route" "internet_access" {
  route_table_id         = aws_route_table.public_rt.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.main_igw.id
}

# Create a NAT Gateway
resource "aws_eip" "nat_eip" {
  vpc = true
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.public_subnet.id
  tags = {
    Name = "nat_gw"
  }
}

# Create Route Table for Private Subnet
resource "aws_route_table" "private_rt" {
  vpc_id = aws_vpc.main_vpc.id
  tags = {
    Name = "private_rt"
  }
}

# Associate Route Table with Private Subnet
resource "aws_route_table_association" "private_rt_assoc" {
  subnet_id      = aws_subnet.private_subnet.id
  route_table_id = aws_route_table.private_rt.id
}

# Create a Route for the NAT Gateway
resource "aws_route" "private_nat_gateway" {
  route_table_id         = aws_route_table.private_rt.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.nat_gw.id
}
