# # modules/api_gateway/main.tf

# resource "aws_api_gateway_rest_api" "crypto_api" {
#   name = var.api_name
# }

# resource "aws_api_gateway_resource" "proxy" {
#   rest_api_id = aws_api_gateway_rest_api.crypto_api.id
#   parent_id   = aws_api_gateway_rest_api.crypto_api.root_resource_id
#   path_part   = "{proxy+}"
# }

# resource "aws_api_gateway_method" "proxy_method" {
#   rest_api_id   = aws_api_gateway_rest_api.crypto_api.id
#   resource_id   = aws_api_gateway_resource.proxy.id
#   http_method   = "ANY"
#   authorization = "NONE"
# }

# resource "aws_api_gateway_integration" "lambda_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.crypto_api.id
#   resource_id             = aws_api_gateway_resource.proxy.id
#   http_method             = aws_api_gateway_method.proxy_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
# }

# resource "aws_api_gateway_deployment" "deploy" {
#   rest_api_id = aws_api_gateway_rest_api.crypto_api.id

#   depends_on = [
#     aws_api_gateway_integration.lambda_integration,
#   ]
# }

# resource "aws_api_gateway_stage" "prod" {
#   deployment_id = aws_api_gateway_deployment.deploy.id
#   rest_api_id   = aws_api_gateway_rest_api.crypto_api.id
#   stage_name    = "prod"
# }

# variable "lambda_arn" {}
# variable "api_name" {}
# variable "region" {
#   default = "ap-south-1"
# }

# output "api_endpoint" {
#   value = "${aws_api_gateway_stage.prod.invoke_url}"
# }

# output "api_gateway" {
#   value = aws_api_gateway_rest_api.crypto_api.id
# }

# output "execution_arn" {
#   value = aws_api_gateway_rest_api.crypto_api.execution_arn
# }

# output "stage_name" {
#   value = aws_api_gateway_stage.prod.stage_name
# }



# modules/api_gateway/main.tf

resource "aws_api_gateway_rest_api" "crypto_api" {
  name = var.api_name
}

resource "aws_api_gateway_resource" "proxy" {
  rest_api_id = aws_api_gateway_rest_api.crypto_api.id
  parent_id   = aws_api_gateway_rest_api.crypto_api.root_resource_id
  path_part   = "{proxy+}"
}

resource "aws_api_gateway_method" "proxy_method" {
  rest_api_id   = aws_api_gateway_rest_api.crypto_api.id
  resource_id   = aws_api_gateway_resource.proxy.id
  http_method   = "ANY"
  authorization = "NONE"
}

# resource "aws_api_gateway_integration" "lambda_integration" {
#   rest_api_id             = aws_api_gateway_rest_api.crypto_api.id
#   resource_id             = aws_api_gateway_resource.proxy.id
#   http_method             = aws_api_gateway_method.proxy_method.http_method
#   integration_http_method = "POST"
#   type                    = "AWS_PROXY"
#   uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
# }



resource "aws_api_gateway_integration" "lambda_integration" {
  rest_api_id             = aws_api_gateway_rest_api.crypto_api.id
  resource_id             = aws_api_gateway_resource.proxy.id
  http_method             = aws_api_gateway_method.proxy_method.http_method
  integration_http_method = "POST" 
  type                    = "AWS" 
  uri                     = "arn:aws:apigateway:${var.region}:lambda:path/2015-03-31/functions/${var.lambda_arn}/invocations"
  request_templates = {
    "application/json" = "$input.json('$')"
  }
}

resource "aws_api_gateway_deployment" "deploy" {
  rest_api_id = aws_api_gateway_rest_api.crypto_api.id

  triggers = {
    redeployment = timestamp() 
  }

  depends_on = [
    aws_api_gateway_integration.lambda_integration,
  ]
}

resource "aws_api_gateway_stage" "prod" {
  deployment_id = aws_api_gateway_deployment.deploy.id
  rest_api_id   = aws_api_gateway_rest_api.crypto_api.id
  stage_name    = "prod"
}

variable "lambda_arn" {}
variable "api_name" {}
variable "region" {
  default = "ap-south-1"
}

output "api_endpoint" {
  value = "${aws_api_gateway_stage.prod.invoke_url}"
}

output "api_gateway" {
  value = aws_api_gateway_rest_api.crypto_api.id
}

output "execution_arn" {
  value = aws_api_gateway_rest_api.crypto_api.execution_arn
}

output "stage_name" {
  value = aws_api_gateway_stage.prod.stage_name
}
