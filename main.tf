# main.tf (Root Directory)

module "vpc" {
  source   = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
}

module "iam" {
  source                 = "./modules/iam"
  aws_region             = var.aws_region
  account_id             = var.account_id
  db_instance_identifier = module.rds.db_identifier
  lambda_function_name   = var.lambda_function_name
}
module "rds" {
  source              = "./modules/rds"
  db_password         = var.db_password
  vpc_id              = module.vpc.vpc_id
  subnet_ids          = module.vpc.private_subnet_ids
  security_group_ids  = [module.vpc.rds_sg_id]
  db_name             = var.db_name
  db_username         = var.db_username
  db_instance_class   = var.db_instance_class
}

module "lambda" {
  source               = "./modules/lambda"
  role_arn             = module.iam.lambda_role_arn
  db_host              = module.rds.db_address
  db_user              = module.rds.db_username
  db_password          = var.db_password
  db_name              = module.rds.db_name
  subnet_ids           = module.vpc.private_subnet_ids
  security_group_ids   = [module.vpc.lambda_sg_id]
  lambda_function_name = var.lambda_function_name
}

module "api_gateway" {
  source               = "./modules/api_gateway"
  lambda_function_arn  = module.lambda.lambda_function_arn
  api_gateway_name     = var.api_gateway_name
  api_gateway_stage_name = var.api_gateway_stage_name
  aws_region           = var.aws_region # Add this line
}
