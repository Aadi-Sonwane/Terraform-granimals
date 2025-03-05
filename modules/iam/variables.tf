# modules/iam/variables.tf

variable "aws_region" {
  type        = string
  description = "AWS region"
}

variable "account_id" {
  type        = string
  description = "AWS account ID"
}

variable "db_instance_identifier" {
  type        = string
  description = "RDS database instance identifier"
}

variable "lambda_function_name" {
  type        = string
  description = "Lambda function name"
}