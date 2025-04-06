provider "aws" {
  region = var.aws_region
}

# S3 Bucket for storing API data
resource "aws_s3_bucket" "etl_bucket" {
  bucket         = var.s3_bucket_name
  force_destroy  = true
}

# IAM Role for Lambda execution
resource "aws_iam_role" "lambda_exec" {
  name = "lambda_etl_execution_role"
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

# IAM Policy Attachments for Lambda
resource "aws_iam_role_policy_attachment" "lambda_basic" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole"
}

resource "aws_iam_role_policy_attachment" "lambda_s3" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonS3FullAccess"
}

resource "aws_iam_role_policy_attachment" "lambda_secretsmanager" {
  role       = aws_iam_role.lambda_exec.name
  policy_arn = "arn:aws:iam::aws:policy/SecretsManagerReadWrite"
}

# Lambda Function
resource "aws_lambda_function" "weather_etl" {
  filename         = "../lambda/lambda.zip"
  function_name    = "weather-fetcher"
  role             = aws_iam_role.lambda_exec.arn
  handler          = "weather_fetcher.lambda_handler"
  runtime          = "python3.11"
  source_code_hash = filebase64sha256("../lambda/lambda.zip")

  environment {
    variables = {
      CITY        = var.city
      S3_BUCKET   = var.s3_bucket_name
      SECRET_NAME = aws_secretsmanager_secret.weather_api.name
    }
  }
}

# EventBridge rule for scheduled execution
resource "aws_cloudwatch_event_rule" "etl_schedule" {
  name                = "every-6-hours"
  schedule_expression = "rate(6 hours)"
}

# EventBridge target for Lambda
resource "aws_cloudwatch_event_target" "etl_target" {
  rule      = aws_cloudwatch_event_rule.etl_schedule.name
  target_id = "lambdaWeatherETL"
  arn       = aws_lambda_function.weather_etl.arn
}

# Permission for EventBridge to invoke Lambda
resource "aws_lambda_permission" "allow_eventbridge" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.weather_etl.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.etl_schedule.arn
}

# Secrets Manager: Store API Key
resource "aws_secretsmanager_secret" "weather_api" {
  name        = "${var.project_name}-weather-api-key"
  description = "API key for weather data"
}

resource "aws_secretsmanager_secret_version" "weather_api_version" {
  secret_id     = aws_secretsmanager_secret.weather_api.id
  secret_string = jsonencode({ api_key = var.weather_api_key })
}
