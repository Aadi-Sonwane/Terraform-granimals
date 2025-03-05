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

![Screenshot 1]("https://asset.cloudinary.com/dw6mhkdfm/1ee9fd3ad04e43db2d5a42aa04acd2a8")
![Screenshot 2](https://asset.cloudinary.com/dw6mhkdfm/958453c4508199c2fe55bbd20f86b8b8)
![Screenshot 3](https://asset.cloudinary.com/dw6mhkdfm/e13c07e20e5dbd109328fff44d04f4e5)
![Screenshot 4](https://asset.cloudinary.com/dw6mhkdfm/481013ddc6a1d50a203f5a45776801ed)
![Screenshot 5](https://asset.cloudinary.com/dw6mhkdfm/532cea50c719fd47607e6edaec30d4ae)
![Screenshot 6](https://asset.cloudinary.com/dw6mhkdfm/144b1dc7da89fc0170a0e70f9626f8ce)



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
    git clone <repository_url>
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
