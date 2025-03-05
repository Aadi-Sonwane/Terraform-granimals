# Terraform Crypto Pipeline

This project uses Terraform to provision an AWS infrastructure for fetching cryptocurrency prices from a public API, storing them in an RDS database, and exposing the data through an API Gateway endpoint.

## Architecture

The architecture consists of the following components:

- **VPC:** A Virtual Private Cloud to provide a secure network environment.
- **RDS:** An RDS database (MySQL or PostgreSQL) to store cryptocurrency price data.
- **Lambda Function:** A Python Lambda function to fetch data from the CoinGecko API and store it in RDS.
- **API Gateway:** An API Gateway endpoint to expose the Lambda function.
- **IAM Roles and Policies:** IAM roles and policies for secure access to AWS resources.

## Screenshots
![Terraform deploy](https://res.cloudinary.com/dw6mhkdfm/image/upload/v1741183924/final_url_tcdsbo.png)
![Terraform deploy](https://res.cloudinary.com/dw6mhkdfm/image/upload/v1741183924/terraform_apply_lqgxtg.png)
![Terraform deploy](https://res.cloudinary.com/dw6mhkdfm/image/upload/v1741183924/vpc_created_pwo6j9.png)
![Terraform deploy](https://res.cloudinary.com/dw6mhkdfm/image/upload/v1741183924/subnets_yolngi.png)
![Terraform deploy](https://res.cloudinary.com/dw6mhkdfm/image/upload/v1741183923/rds_dduetz.png)
![Terraform deploy](https://res.cloudinary.com/dw6mhkdfm/image/upload/v1741183923/lambda_wxy2aa.png)
![Terraform deploy](https://res.cloudinary.com/dw6mhkdfm/image/upload/v1741183923/final_output_cqd0d5.png)

## Prerequisites

- AWS account
- Terraform installed
- AWS CLI configured
- Python 3.9 (or later)

## Project Structure

```plaintext
terraform-crypto-pipeline/
├── main.tf
├── terraform.tfvars
├── modules/
│   ├── vpc/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── rds/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── iam/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   ├── lambda/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
│   │   └── lambda_function/
│   │       ├── lambda_function.py
│   │       └── requirements.txt
│   ├── api_gateway/
│   │   ├── main.tf
│   │   ├── variables.tf
│   │   ├── outputs.tf
├── screenshots/
```

## Setup

1. **Clone the repository:**

    ```bash
    git clone [<repository_url>](https://github.com/Aadi-Sonwane/Terraform-granimals.git)
    cd terraform-crypto-pipeline
    ```

2. **Configure `terraform.tfvars`:**

    Replace placeholder values in `terraform.tfvars` with your AWS credentials, desired configurations, and a strong password for your RDS instance.

    Example:

    ```terraform
    aws_region = "us-east-1"
    account_id = "YOUR_AWS_ACCOUNT_ID"
    db_password = "YOUR_RDS_PASSWORD"
    vpc_cidr = "10.0.0.0/24"
    db_name = "cryptodb"
    db_username = "cryptouser"
    db_instance_class = "db.t3.micro"
    api_gateway_name = "crypto-api"
    api_gateway_stage_name = "prod"
    lambda_function_name = "crypto-price-fetcher"
    ```

3. **Initialize Terraform:**

    ```bash
    terraform init
    ```

4. **Plan the infrastructure:**

    ```bash
    terraform plan
    ```

5. **Apply the changes:**

    ```bash
    terraform apply
    ```

6. **Access the API Gateway URL:**

    - The API Gateway URL will be displayed in the Terraform output.
    - You can use `curl` or Postman to test the API endpoint.

## Lambda Function Dependencies

The Lambda function uses the following Python libraries:

- `requests`: For making HTTP requests to the CoinGecko API.
- `pymysql`: For connecting to the RDS database.

These dependencies are listed in `modules/lambda/lambda_function/requirements.txt`.

## Security Considerations

- Use strong passwords for RDS.
- Restrict IAM permissions to the minimum necessary.
- Use VPC for Lambda and RDS.
- Enable API Gateway throttling.
- Store sensitive information (e.g., RDS passwords) in AWS Secrets Manager.
- Restrict EC2 permissions in IAM policy to the minimum needed.

## Cleanup

To destroy the infrastructure, run:

```bash
terraform destroy
