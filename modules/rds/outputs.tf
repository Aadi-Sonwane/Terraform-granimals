# modules/rds/outputs.tf

output "db_address" {
  value = aws_db_instance.rds_instance.address
}

output "db_username" {
  value = aws_db_instance.rds_instance.username
}

output "db_name" {
  value = aws_db_instance.rds_instance.db_name
}