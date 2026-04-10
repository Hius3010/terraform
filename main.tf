provider "aws" {
  region = var.aws_region
}

resource "aws_instance" "tf-aws" {
  ami           = var.ami_id
  instance_type = var.instance_type
  security_groups = [ aws_security_group.tf-aws-sg.name ]
  key_name = aws_key_pair.tf-aws-key.key_name
  tags = {
    Name = "tf-aws"
  }
}

resource "aws_security_group" "tf-aws-sg" {
  name        = "tf-aws-sg"
  description = "Security group for tf-aws instance"

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "tls_private_key" "tf-aws-key" {
  algorithm = "RSA"
  rsa_bits = 4096
}

resource "aws_key_pair" "tf-aws-key" {
  key_name   = var.key_name
  public_key = tls_private_key.tf-aws-key.public_key_openssh
}

resource "local_file" "private_key" {
  content  = tls_private_key.tf-aws-key.private_key_pem
  filename = "${var.key_name}.pem"
  file_permission = "0600"
}