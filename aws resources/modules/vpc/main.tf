resource "aws_vpc" "this" {

  cidr_block = var.vpc_cidr

  tags = {
    Name = var.vpc_name
  }
}

resource "aws_subnet" "public_subnet1" {

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet1_cidr
  availability_zone       = var.public_subnet1_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet1_name
  }
}

resource "aws_subnet" "public_subnet2" {

  vpc_id                  = aws_vpc.this.id
  cidr_block              = var.public_subnet2_cidr
  availability_zone       = var.public_subnet2_az
  map_public_ip_on_launch = true

  tags = {
    Name = var.public_subnet2_name
  }
}

resource "aws_subnet" "private_subnet1" {

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet1_cidr
  availability_zone = var.private_subnet1_az

  tags = {
    Name = var.private_subnet1_name
  }
}

resource "aws_subnet" "private_subnet2" {

  vpc_id            = aws_vpc.this.id
  cidr_block        = var.private_subnet2_cidr
  availability_zone = var.private_subnet2_az

  tags = {
    Name = var.private_subnet2_name
  }
}