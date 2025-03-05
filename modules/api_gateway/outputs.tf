# modules/api_gateway/outputs.tf

output "invoke_url" {
  value = "${aws_api_gateway_stage.crypto_stage.invoke_url}${aws_api_gateway_resource.crypto_resource.path_part}"
}



output "api_gateway_id" {
  value = aws_api_gateway_rest_api.crypto_api.id
  description = "The ID of the API Gateway."
}

output "api_gateway_execution_arn" {
  value = aws_api_gateway_rest_api.crypto_api.execution_arn
  description = "The execution ARN of the API Gateway."
}