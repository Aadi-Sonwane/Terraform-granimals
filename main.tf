# main.tf

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "ap-south-1"
}

# VPC and Subnets
resource "aws_vpc" "main" {
  cidr_block = "10.0.0.0/16"
  
}

resource "aws_subnet" "public_a" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.1.0/24"
  availability_zone = "ap-south-1a"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet A"
  }
}

resource "aws_subnet" "public_c" {
  vpc_id            = aws_vpc.main.id
  cidr_block        = "10.0.2.0/24"
  availability_zone = "ap-south-1c"
  map_public_ip_on_launch = true

  tags = {
    Name = "Public Subnet C"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.main.id
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.gw.id
}

resource "aws_route_table_association" "public_a" {
  subnet_id      = aws_subnet.public_a.id
  route_table_id = aws_route_table.public.id
}

resource "aws_route_table_association" "public_c" {
  subnet_id      = aws_subnet.public_c.id
  route_table_id = aws_route_table.public.id
}

# RDS Module
module "rds" {
  source           = "./modules/rds"
  db_name          = "cryptodb"
  db_username      = "admin"
  db_password      = "Test12345!"
  allocated_storage = 20
  instance_class   = "db.t3.micro"
  region           = "ap-south-1"
  vpc_id           = aws_vpc.main.id
  subnet_a_id      = aws_subnet.public_a.id
  subnet_c_id      = aws_subnet.public_c.id
}

module "lambda" {
  source                    = "./modules/lambda"
  function_name             = "crypto-price-fetcher"
  database_address          = module.rds.db_instance_address
  database_name             = module.rds.db_name
  database_user             = module.rds.db_username
  database_password         = module.rds.db_password
  vpc_id                    = aws_vpc.main.id
  subnet_a_id               = aws_subnet.public_a.id
  subnet_c_id               = aws_subnet.public_c.id
  api_gateway_id            = module.api_gateway.api_gateway
  account_id                = data.aws_caller_identity.current.account_id
}

data "aws_caller_identity" "current" {}
# API Gateway Module
module "api_gateway" {
  source      = "./modules/api_gateway"
  lambda_arn  = module.lambda.lambda_arn
  api_name    = "crypto-api"
}

# Outputs
output "api_endpoint" {
  value = module.api_gateway.api_endpoint
}

output "rds_endpoint" {
  value = module.rds.db_instance_address
}