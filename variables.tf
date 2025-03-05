# variables.tf (Root Directory)

variable "aws_region" {
  type        = string
  default     = "us-east-1"
  description = "AWS region"
}

variable "db_password" {
  type        = string
  sensitive   = true
  description = "RDS database password"
}

variable "vpc_cidr" {
  type        = string
  default     = "10.0.0.0/16"
  description = "VPC CIDR block"
}

variable "db_name" {
  type        = string
  default     = "cryptodb"
  description = "RDS database name"
}

variable "db_username" {
  type        = string
  default     = "cryptouser"
  description = "RDS database username"
}

variable "db_instance_class" {
  type        = string
  default     = "db.t3.micro"
  description = "RDS instance class"
}

variable "api_gateway_name" {
  type        = string
  default     = "crypto-price-api"
  description = "API Gateway name"
}

variable "api_gateway_stage_name" {
  type        = string
  default     = "prod"
  description = "API Gateway stage name"
}

variable "lambda_function_name" {
  type        = string
  default     = "crypto-price-fetcher"
  description = "Lambda function name"
}
variable "account_id" {
  type        = string
  description = "AWS account ID"
  sensitive   = true 
  }