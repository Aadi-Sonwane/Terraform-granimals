resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr
  count      = var.existing_vpc_id == null ? 1 : 0 # Create VPC only if existing_vpc_id is null
    tags = {
    Name = "crypto-pipeline-vpc" # Replace with your desired name
  }
}

data "aws_vpc" "existing" {
  id    = var.existing_vpc_id
  count = var.existing_vpc_id != null ? 1 : 0 # get existing vpc if existing_vpc_id is not null
}

locals {
  vpc_id = var.existing_vpc_id == null ? aws_vpc.main[0].id : data.aws_vpc.existing[0].id
}

resource "aws_subnet" "private" {
  count             = 2
  vpc_id            = local.vpc_id
  cidr_block        = cidrsubnet(var.vpc_cidr, 3, count.index * 3) # Changed to 3
  availability_zone = data.aws_availability_zones.available.names[count.index]
  tags = {
    Name = "crypto-private-subnet-${count.index + 1}" # Replace with desired naming pattern
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = local.vpc_id
  count  = var.existing_vpc_id == null ? 1 : 0
}

resource "aws_route_table" "public" {
  vpc_id = local.vpc_id
  count  = var.existing_vpc_id == null ? 1 : 0

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw[0].id
  }
}

resource "aws_security_group" "lambda_sg" {
  name_prefix = "lambda-sg-"
  vpc_id      = local.vpc_id
  tags = {
    Name = "lambda-security-group"
  }
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = [var.vpc_cidr]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg-"
  vpc_id      = local.vpc_id
  tags = {
    Name = "rds-security-group"
  }
  ingress {
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.lambda_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

data "aws_availability_zones" "available" {
  state = "available"
}