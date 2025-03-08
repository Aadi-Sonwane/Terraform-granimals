# modules/rds/main.tf

variable "db_name" {}
variable "db_username" {}
variable "db_password" {}
variable "allocated_storage" {}
variable "instance_class" {}
variable "region" {
  default = "ap-south-1"
}
variable "vpc_id" {}
variable "subnet_a_id" {}
variable "subnet_c_id" {}

resource "aws_db_subnet_group" "default" {
  name       = "main"
  subnet_ids = [var.subnet_a_id, var.subnet_c_id]
}

resource "aws_security_group" "rds_sg" {
  name        = "rds_sg"
  description = "Security group for RDS instance"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] 
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_db_instance" "crypto_db" {
  allocated_storage    = var.allocated_storage
  storage_type         = "gp2"
  engine               = "mysql"
  engine_version       = "8.0"
  instance_class       = var.instance_class
  username             = var.db_username
  password             = var.db_password
  db_subnet_group_name = aws_db_subnet_group.default.name
  vpc_security_group_ids = [aws_security_group.rds_sg.id]
  skip_final_snapshot  = true
  publicly_accessible  = false
}



output "db_instance_address" {
  value = aws_db_instance.crypto_db.address
}

output "db_name" {
  value = var.db_name
}

output "db_username" {
  value = var.db_username
}

output "db_password" {
  value = var.db_password
}



