terraform {
  required_version = ">= 1.5.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    local = {
      source  = "hashicorp/local"
      version = "~> 2.5"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  instance_name = "tf-aws"
}

resource "aws_security_group" "tf_aws_sg" {
  name        = "${local.instance_name}-sg"
  description = "Security group for ${local.instance_name} instance"

  ingress {
    description = "Allow SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = var.allowed_ssh_cidrs
  }

  egress {
    description = "Allow all outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${local.instance_name}-sg"
  }
}

resource "tls_private_key" "tf_aws_key" {
  algorithm = "RSA"
  rsa_bits  = 4096
}

resource "aws_key_pair" "tf_aws_key" {
  key_name   = var.key_name
  public_key = tls_private_key.tf_aws_key.public_key_openssh

  tags = {
    Name = var.key_name
  }
}

resource "aws_instance" "tf_aws" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  vpc_security_group_ids = [aws_security_group.tf_aws_sg.id]
  key_name               = aws_key_pair.tf_aws_key.key_name

  tags = {
    Name = local.instance_name
  }
}

resource "local_sensitive_file" "private_key" {
  content         = tls_private_key.tf_aws_key.private_key_pem
  filename        = "${path.module}/${var.key_name}.pem"
  file_permission = "0600"
}
