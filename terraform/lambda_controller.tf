resource "aws_sns_topic" "eth_block_sns" {
  name = "eth_block_topic"

  tags = {
    Name        = "eth_block_sns"
  }
}

resource "aws_sns_topic_subscription" "invoke_with_sns" {
  topic_arn = aws_sns_topic.eth_block_sns.arn
  protocol  = "lambda"
  endpoint  = aws_lambda_function.store_traces.arn
}

resource "aws_lambda_permission" "allow_sns_invoke" {
  statement_id  = "AllowExecutionFromSNS"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.store_traces.arn
  principal     = "sns.amazonaws.com"
  source_arn    = aws_sns_topic.eth_block_sns.arn
}

resource "aws_lambda_function" "store_traces_controller" {
  function_name = "store_traces_controller"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.upload_lambda_store_traces_controller.key

  runtime = "python3.8"
  handler = "store_traces_controller.handler"
  timeout = 30

  source_code_hash = data.archive_file.zip_store_traces_controller.output_base64sha256

  role = aws_iam_role.role_for_LDC_controller.arn
}

resource "aws_cloudwatch_log_group" "store_traces_controller_cloudwatch" {
  name = "/aws/lambda/${aws_lambda_function.store_traces_controller.function_name}"

  retention_in_days = 30
}

resource "aws_iam_role_policy" "lambda_controller_policy" {
  name = "lambda_controller_policy"
  role = aws_iam_role.role_for_LDC_controller.id

  policy = file("./policies/lambda_controller_policy.json")
}


resource "aws_iam_role" "role_for_LDC_controller" {
  name = "lambda_controller_role"

  assume_role_policy = file("./policies/assume_role_policy.json")

}