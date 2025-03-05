# modules/api_gateway/main.tf

resource "aws_api_gateway_rest_api" "crypto_api" {
  name        = var.api_gateway_name
  description = "API Gateway for crypto price data."
}

resource "aws_api_gateway_resource" "crypto_resource" {
  rest_api_id = aws_api_gateway_rest_api.crypto_api.id
  parent_id   = aws_api_gateway_rest_api.crypto_api.root_resource_id
  path_part   = "crypto"
}

resource "aws_api_gateway_method" "crypto_method" {
  rest_api_id   = aws_api_gateway_rest_api.crypto_api.id
  resource_id   = aws_api_gateway_resource.crypto_resource.id
  http_method   = "GET" # Or "POST" - MUST MATCH integration_http_method
  authorization = "NONE"
}

resource "aws_api_gateway_integration" "crypto_integration" {
  rest_api_id             = aws_api_gateway_rest_api.crypto_api.id
  resource_id             = aws_api_gateway_resource.crypto_resource.id
  http_method             = aws_api_gateway_method.crypto_method.http_method
  integration_http_method = "GET" # Or "POST" - MUST MATCH http_method
  type                    = "AWS_PROXY"
  uri                     = "arn:aws:apigateway:${var.aws_region}:lambda:path/2015-03-31/functions/${var.lambda_function_arn}/invocations"
}

resource "aws_api_gateway_deployment" "crypto_deployment" {
  rest_api_id = aws_api_gateway_rest_api.crypto_api.id

  depends_on = [
    aws_api_gateway_integration.crypto_integration,
  ]
}

resource "aws_api_gateway_stage" "crypto_stage" {
  deployment_id = aws_api_gateway_deployment.crypto_deployment.id
  rest_api_id   = aws_api_gateway_rest_api.crypto_api.id
  stage_name    = var.api_gateway_stage_name
}

output "api_gateway_execution_arn" {
  value = aws_api_gateway_rest_api.crypto_api.execution_arn
}