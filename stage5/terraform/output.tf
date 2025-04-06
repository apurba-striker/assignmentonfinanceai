output "s3_bucket_name" {
  description = "Name of the S3 bucket storing API data"
  value       = aws_s3_bucket.api_data_bucket.id
}

output "lambda_function_name" {
  description = "Deployed Lambda function"
  value       = aws_lambda_function.api_lambda.function_name
}

output "eventbridge_rule" {
  description = "Schedule rule triggering the Lambda function"
  value       = aws_cloudwatch_event_rule.lambda_schedule.name
}

output "secret_name" {
  description = "Secrets Manager secret storing API key"
  value       = aws_secretsmanager_secret.weather_api_key.name
}
