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
resource "aws_security_group" "ssh_hhtp_https" {
  name        = "ssh_hhtp_https"
  description = "Allow ssh_hhtp_https inbound traffic"

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
  ingress {
    description = "https"
    from_port   = 443
    to_port     = 443
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
  instance_type          = local.workspace["instance_type"]
  key_name               = "Frankfurt"
  vpc_security_group_ids = ["${aws_security_group.ssh_hhtp_https.id}"]
  ebs_block_device {
    device_name = "sdb"
    volume_type = "gp2"
    volume_size = "1"
  }
  ebs_block_device {
    device_name = "sde"
    volume_type = "gp2"
    volume_size = "1"
  }
  ebs_block_device {
    device_name = "sdf"
    volume_type = "gp2"
    volume_size = "1"
  }
  tags = {
    Name = "Hello Centos7 ${terraform.workspace}"
  }
}
