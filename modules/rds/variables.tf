# modules/rds/variables.tf

variable "db_password" {
  type        = string
  sensitive   = true
  description = "The password for the RDS database."
}

variable "vpc_id" {
  type        = string
  description = "The VPC ID"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs"
}

variable "db_name" {
  type        = string
  description = "RDS database name"
}

variable "db_username" {
  type        = string
  description = "RDS database username"
}

variable "db_instance_class" {
  type        = string
  description = "RDS instance class"
}