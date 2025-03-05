# modules/lambda/outputs.tf

output "lambda_function_arn" {
  value = aws_lambda_function.crypto_lambda.arn
}