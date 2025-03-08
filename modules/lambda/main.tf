

# modules/lambda/main.tf

resource "aws_lambda_function" "crypto_fetcher" {
  function_name    = var.function_name
  filename         = "./crypto_fetcher.zip"
  handler          = "lambda_function.lambda_handler"
  runtime          = "python3.9"
  role             = aws_iam_role.lambda_role.arn
  timeout          = 30

  environment {
    variables = {
      DATABASE_ADDRESS = var.database_address
      DATABASE_NAME    = var.database_name
      DATABASE_USER    = var.database_user
      DATABASE_PASSWORD = var.database_password
    }
  }

  vpc_config {
    subnet_ids         = [var.subnet_a_id, var.subnet_c_id]
    security_group_ids = [aws_security_group.lambda_sg.id]
  }
}

resource "aws_security_group" "lambda_sg" {
  name        = "lambda_sg"
  description = "Security group for Lambda function"
  vpc_id      = var.vpc_id

  egress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_iam_role" "lambda_role" {
  name = "crypto-lambda-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "lambda_policy" {
  name = "crypto-lambda-policy"

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = [
          "rds:*",
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents",
          "ec2:CreateNetworkInterface",
          "ec2:DescribeNetworkInterfaces",
          "ec2:DeleteNetworkInterface"
        ],
        Effect   = "Allow",
        Resource = "*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "lambda_policy_attach" {
  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.lambda_policy.arn
}

resource "aws_lambda_permission" "allow_api_gateway" {
  statement_id  = "AllowAPIGatewayInvoke"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.crypto_fetcher.function_name
  principal     = "apigateway.amazonaws.com"

  source_arn = "arn:aws:execute-api:${var.region}:${var.account_id}:${var.api_gateway_id}/*/*/*"
}

variable "function_name" {}
variable "database_address" {}
variable "database_name" {}
variable "database_user" {}
variable "database_password" {}
variable "api_gateway_id" {}
variable "region" {
  default = "ap-south-1"
}
variable "account_id" {}
variable "vpc_id" {}
variable "subnet_a_id" {}
variable "subnet_c_id" {}

output "lambda_arn" {
  value = aws_lambda_function.crypto_fetcher.arn
}
