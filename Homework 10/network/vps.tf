/*
  vpc
*/
resource "aws_vpc" "test" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  tags = {
    Name = "vps-test"
  }
}
/*
  gateway
*/
resource "aws_internet_gateway" "test" {
  vpc_id = aws_vpc.test.id
  tags = {
    Name = "aws_internet_gateway-test"
  }
}
/*
  security group
*/
resource "aws_security_group" "nat" {
  name = "vpc_nat"


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  vpc_id = aws_vpc.test.id

  tags = {
    Name = "NATSG"
  }
}
resource "aws_eip" "nat" {
  instance = aws_instance.nat.id
  vpc      = true
}
/*
  Public Subnet
*/
resource "aws_subnet" "test-public" {
  vpc_id = aws_vpc.test.id

  cidr_block        = var.public_subnet_cidr
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Public Subnet"
  }
}
resource "aws_route_table" "test-public" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.test.id
  }

  tags = {
    Name = "Public Subnet"
  }
}
resource "aws_route_table_association" "test-public" {
  subnet_id      = aws_subnet.test-public.id
  route_table_id = aws_route_table.test-public.id
}
/*
  Private Subnet
*/
resource "aws_subnet" "test-private" {
  vpc_id = aws_vpc.test.id

  cidr_block        = var.private_subnet_cidr
  availability_zone = "eu-central-1a"

  tags = {
    Name = "Private Subnet"
  }
}
resource "aws_route_table" "test-private" {
  vpc_id = aws_vpc.test.id

  route {
    cidr_block  = "0.0.0.0/0"
    instance_id = aws_instance.nat.id
  }

  tags = {
    Name = "Private Subnet"
  }
}
resource "aws_route_table_association" "test-private" {
  subnet_id      = aws_subnet.test-private.id
  route_table_id = aws_route_table.test-private.id
}
/*
  NAT
*/
resource "aws_instance" "nat" {
  ami                         = "ami-0d5a279a8a0132ff5"
  availability_zone           = "eu-central-1a"
  instance_type               = "t2.micro"
  key_name                    = "Frankfurt"
  vpc_security_group_ids      = ["${aws_security_group.nat.id}"]
  subnet_id                   = aws_subnet.test-public.id
  associate_public_ip_address = true
  source_dest_check           = false

  tags = {
    Name = "VPC NAT"
  }
}
