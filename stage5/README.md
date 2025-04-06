# 🌦️ Weather ETL Pipeline with AWS (Stage 5)

This project implements a secure, automated pipeline to fetch weather data from a public API, store it in Amazon S3, and run it periodically via AWS Lambda and EventBridge. API keys are stored securely using Secrets Manager.

---

##  Project Structure

```
stage-5-etl-pipeline/
├── terraform/
│   ├── main.tf
│   ├── variables.tf
│   ├── outputs.tf
│   ├── secrets.auto.tfvars
├── lambda/
│   ├── weather_fetcher.py
│   ├── requirements.txt
│   ├── build.sh
│   └── lambda.zip
└── README.md
```

---

##  Features

- Fetches real-time weather data using [OpenWeatherMap API](https://openweathermap.org/api)
- Stores response data in S3 with timestamped filenames
- Lambda scheduled to run every hour via EventBridge
- API key securely stored in AWS Secrets Manager
- Infrastructure as Code using Terraform

---

##  Prerequisites

- AWS CLI & credentials configured
- Terraform ≥ 1.3
- Python 3.11+
- IAM user/role with permissions for:
  - S3
  - Lambda
  - EventBridge
  - IAM
  - Secrets Manager

---

##  Setup Instructions

### 1. Clone the repository

```bash
git clone https://github.com/your-org/stage-5-etl-pipeline.git
cd stage-5-etl-pipeline
```

### 2. Build Lambda Deployment Package

```bash
cd lambda
./build.sh
cd ..
```

> This creates a zip archive in `lambda/lambda.zip`

---

### 3. Create `secrets.auto.tfvars` file

```hcl
api_key = "your_openweathermap_api_key"
city    = "New York"
```

### 4. Initialize and Deploy with Terraform

```bash
cd terraform
terraform init
terraform apply
```

> Confirm when prompted. Terraform will:
> - Create an S3 bucket
> - Deploy the Lambda function
> - Set up an EventBridge schedule
> - Store the API key in Secrets Manager

---

## How it Works

- EventBridge triggers Lambda every hour
- Lambda fetches weather data for the specified city
- Data is saved as JSON in your S3 bucket
- Lambda reads the API key securely from Secrets Manager

---

##  Sample Output

```json
{
  "status": "success",
  "file": "New_York_2025-04-01T09:15:23.000Z.json"
}
```

Check CloudWatch Logs for real-time debugging.

---

## Outputs

| Resource          | Description                     |
|------------------|---------------------------------|
| `s3_bucket_name` | S3 bucket storing API results   |
| `lambda_function_name` | Name of the deployed Lambda |
| `eventbridge_rule`     | Hourly EventBridge trigger  |
| `secret_name`          | API key stored securely     |

---

## Cleanup

```bash
terraform destroy
```

---

##  Notes

- You can update `schedule_expression` in `variables.tf` to change the interval
- Extend functionality for DynamoDB or SNS alerts easily
- For higher security, rotate secrets periodically

---

##  Support

Need help? Open an issue or ping me via [ChatGPT 😄].