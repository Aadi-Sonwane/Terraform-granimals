# modules/lambda/variables.tf

variable "role_arn" {
  type        = string
  description = "ARN of the IAM role for the Lambda function"
}

variable "db_host" {
  type        = string
  description = "RDS database host"
}

variable "db_user" {
  type        = string
  description = "RDS database username"
}

variable "db_password" {
  type        = string
  description = "RDS database password"
  sensitive   = true
}

variable "db_name" {
  type        = string
  description = "RDS database name"
}

variable "subnet_ids" {
  type        = list(string)
  description = "List of subnet IDs for the Lambda VPC"
}

variable "security_group_ids" {
  type        = list(string)
  description = "List of security group IDs for the Lambda VPC"
}

variable "lambda_function_name" {
  type        = string
  description = "Name of the Lambda function"
}

variable "api_gateway_execution_arn" {
  type        = string
  description = "The execution ARN of the API Gateway."
}
