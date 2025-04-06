variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

variable "project_name" {
  description = "Project identifier"
  type        = string
  default     = "weather-etl"
}

variable "s3_bucket_name" {
  description = "Name of the S3 bucket to store API data"
  type        = string
  default     = "weather-etl-api-data"
}

variable "lambda_function_name" {
  description = "Lambda function name"
  type        = string
  default     = "fetch-weather-api"
}

variable "lambda_runtime" {
  description = "Lambda runtime environment"
  type        = string
  default     = "python3.11"
}

variable "lambda_handler" {
  description = "Lambda handler"
  type        = string
  default     = "lambda_function.lambda_handler"
}

variable "schedule_expression" {
  description = "EventBridge schedule for Lambda (cron or rate)"
  type        = string
  default     = "rate(1 hour)"
}

variable "weather_api_url" {
  description = "The public weather API endpoint"
  type        = string
  default     = "https://api.weatherapi.com/v1/current.json"
}

variable "weather_api_key" {
  description = "Weather API key (to be stored in Secrets Manager)"
  type        = string
}
