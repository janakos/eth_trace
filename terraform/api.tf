# Set up lambda to write into SNS topic
resource "aws_lambda_function" "get_traces" {
  function_name = "get_traces"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.upload_lambda_get_traces.key

  runtime = "python3.8"
  handler = "get_traces.handler"
  timeout = 30

  source_code_hash = data.archive_file.zip_get_traces.output_base64sha256

  role = aws_iam_role.role_for_LDC_api.arn
}

# Cloudwatch
resource "aws_cloudwatch_log_group" "get_traces_cloudwatch" {
  name = "/aws/lambda/${aws_lambda_function.get_traces.function_name}"

  retention_in_days = 30
}

# Permissions
resource "aws_iam_role_policy" "lambda_api_policy" {
  name = "lambda_controller_policy"
  role = aws_iam_role.role_for_LDC_api.id

  policy = file("./policies/lambda_api_policy.json")
}


resource "aws_iam_role" "role_for_LDC_api" {
  name = "lambda_api_role"

  assume_role_policy = file(var.assume_role_path)

}

# Set up API
resource "aws_api_gateway_rest_api" "apiLambda" {
  name        = "blockTraces"

}

resource "aws_api_gateway_resource" "readResource" {
  rest_api_id = aws_api_gateway_rest_api.apiLambda.id
  parent_id   = aws_api_gateway_rest_api.apiLambda.root_resource_id
  path_part   = "readBlocks"

}

resource "aws_api_gateway_method" "readMethod" {
   rest_api_id   = aws_api_gateway_rest_api.apiLambda.id
   resource_id   = aws_api_gateway_resource.readResource.id
   http_method   = "POST"
   authorization = "NONE"
}

resource "aws_api_gateway_integration" "readInt" {
   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   resource_id = aws_api_gateway_resource.readResource.id
   http_method = aws_api_gateway_method.readMethod.http_method

   integration_http_method = "POST"
   type                    = "AWS_PROXY"
   uri                     = aws_lambda_function.get_traces.invoke_arn

}

resource "aws_api_gateway_deployment" "apideploy" {
   depends_on = [aws_api_gateway_integration.readInt]

   rest_api_id = aws_api_gateway_rest_api.apiLambda.id
   stage_name  = "dev"
}

resource "aws_lambda_permission" "readPermission" {
   statement_id  = "AllowExecutionFromAPIGateway"
   action        = "lambda:InvokeFunction"
   function_name = aws_lambda_function.get_traces.function_name
   principal     = "apigateway.amazonaws.com"

   source_arn = "${aws_api_gateway_rest_api.apiLambda.execution_arn}/dev/POST/readBlocks"

}

output "base_url" {
  value = aws_api_gateway_deployment.apideploy.invoke_url
}
