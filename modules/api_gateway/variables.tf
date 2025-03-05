# modules/api_gateway/variables.tf

variable "api_gateway_name" {
  type        = string
  description = "API Gateway name"
}

variable "api_gateway_stage_name" {
  type        = string
  description = "API Gateway stage name"
}

variable "lambda_function_arn" {
  type        = string
  description = "The ARN of the Lambda function."
}

variable "aws_region" {
  type        = string
  description = "AWS region"
}