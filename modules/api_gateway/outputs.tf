# modules/api_gateway/outputs.tf

output "invoke_url" {
  value = "${aws_api_gateway_stage.crypto_stage.invoke_url}${aws_api_gateway_resource.crypto_resource.path_part}"
}