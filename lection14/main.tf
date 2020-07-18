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
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}
resource "aws_security_group" "ssh" {
  name        = "ssh"
  description = "Allow ssh"

  ingress {
    description = "ssh"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  ingress {
    description = "http"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_test"
  }
}
resource "aws_instance" "Centos7" {
  ami                    = data.aws_ami.Centos7.id
  instance_type          = "t2.micro"
  key_name               = "Frankfurt"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}"]
  tags = {
    Name = "Centos7"
  }
}
resource "aws_instance" "Ubuntu" {
  ami                    = data.aws_ami.ubuntu.id
  instance_type          = "t2.micro"
  key_name               = "Frankfurt"
  vpc_security_group_ids = ["${aws_security_group.ssh.id}"]
  tags = {
    Name = "Ubuntu"
  }
}
