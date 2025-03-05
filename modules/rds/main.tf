# modules/rds/main.tf

resource "aws_db_subnet_group" "rds_subnet_group" {
  name       = "crypto-rds-subnet-group"
  subnet_ids = var.subnet_ids
}

resource "aws_db_instance" "rds_instance" {
  allocated_storage      = 20
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = var.db_instance_class
  username               = var.db_username
  password               = var.db_password
  parameter_group_name   = "default.mysql8.0"
  skip_final_snapshot    = true
  vpc_security_group_ids = var.security_group_ids
  db_subnet_group_name   = aws_db_subnet_group.rds_subnet_group.name
  db_name                = var.db_name
  identifier             = "crypto-rds-instance" 
 
}

output "db_identifier" {
  value = aws_db_instance.rds_instance.identifier
}