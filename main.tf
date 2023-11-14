# terraform
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}
provider "aws" {
  region = "${var.region}"
  access_key = "${var.access}"
  secret_key = "${var.secret}"
}
resource "tls_private_key" "pemkey" {
  algorithm = "RSA"
  rsa_bits  = 4096
}
resource "aws_key_pair" "keypair" {
  key_name   = "${var.key}"
  public_key = tls_private_key.pemkey.public_key_openssh
}
resource "local_file" "privatekey" {
  content  = tls_private_key.pemkey.private_key_pem
  filename = "${var.key}"
}
resource "aws_instance" "ec2instance" {
  ami           = ami-078c1149d8ad719a7
  instance_type = "t2.micro"
  key_name = aws_key_pair.pemkey.key_name

  tags = {
    Name = "terraform_ins"
  }
}
