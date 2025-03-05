# terraform.tfvars (Root Directory)

aws_region             = "us-east-1"
db_password            = "Test12345!" 
vpc_cidr               = "10.0.0.0/16"
db_name                = "cryptodb"
db_username            = "cryptouser"
db_instance_class      = "db.t3.micro"
api_gateway_name       = "crypto-api"
api_gateway_stage_name = "prod"
lambda_function_name   = "crypto-price-fetcher"
account_id = " " 
