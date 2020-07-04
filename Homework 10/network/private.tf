data "aws_ami" "Centos7" {
  most_recent = true

  filter {
    name   = "name"
    values = ["CentOS Linux 7 x86_64 HVM EBS *"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
  owners = ["679593333241"]
}
resource "aws_security_group" "test2" {
  name        = "vpc_db"
  description = "Allow incoming database connections."

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${var.vpc_cidr}"]
  }

  vpc_id = aws_vpc.test.id

  tags = {
    Name = "test2"
  }
}

resource "aws_instance" "test2" {
  ami                    = data.aws_ami.Centos7.id
  availability_zone      = "eu-central-1a"
  instance_type          = "t2.micro"
  key_name               = "Frankfurt"
  vpc_security_group_ids = ["${aws_security_group.test2.id}"]
  subnet_id              = aws_subnet.test-private.id
  source_dest_check      = false

  tags = {
    Name = "test2"
  }
}
