# Lambda
output "lambda_bucket_name" {
  description = "Name of the S3 bucket used to store function code."

  value = aws_s3_bucket.lambda_bucket.id
}

output "lambda_store_traces" {
  description = "store traces lambda"

  value = aws_lambda_function.store_traces.function_name
}

output "lambda_store_traces_controller" {
  description = "store traces lambda controller"

  value = aws_lambda_function.store_traces_controller.function_name
}


output "lambda_get_traces" {
  description = "get traces lambda"

  value = aws_lambda_function.get_traces.function_name
}

# SNS
output "sns_eth_block" {
  description = "sns block topic"

  value = aws_sns_topic.eth_block_sns.name
}

# DynamoDB
output "eth_traces_dynamodb" {
  description = "traces dynamodb"

  value = aws_dynamodb_table.dynamodb-table.name
}

# API Gateway
output "eth_traces_api" {
  description = "traces API"

  value = aws_api_gateway_rest_api.apiLambda.name
}

