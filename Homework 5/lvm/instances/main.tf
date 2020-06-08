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
resource "aws_ebs_volume" "a" {
  availability_zone = aws_instance.Centos7.availability_zone
  size              = "1"
  tags = {
    Name = "a"
  }
}
resource "aws_ebs_volume" "b" {
  availability_zone = aws_instance.Centos7.availability_zone
  size              = "1"
  tags = {
    Name = "b"
  }
}
resource "aws_ebs_volume" "c" {
  availability_zone = aws_instance.Centos7.availability_zone
  size              = "1"
  tags = {
    Name = "c"
  }
}
resource "aws_volume_attachment" "a" {
  device_name = "/dev/sdb"
  volume_id   = aws_ebs_volume.a.id
  instance_id = aws_instance.Centos7.id
}
resource "aws_volume_attachment" "b" {
  device_name = "/dev/sde"
  volume_id   = aws_ebs_volume.b.id
  instance_id = aws_instance.Centos7.id
}
resource "aws_volume_attachment" "c" {
  device_name = "/dev/sdf"
  volume_id   = aws_ebs_volume.c.id
  instance_id = aws_instance.Centos7.id
}
resource "aws_instance" "Centos7" {
  ami                    = data.aws_ami.Centos7.id
  instance_type          = local.workspace["instance_type"]
  user_data              = file("scripts/lvm.sh")
  key_name               = "Frankfurt"
  vpc_security_group_ids = ["${aws_security_group.ssh_hhtp_https.id}"]
  tags = {
    Name = "Hello Centos7 ${terraform.workspace}"
  }
}
