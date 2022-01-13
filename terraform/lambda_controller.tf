resource "aws_sns_topic" "eth_block_sns" {
  name = "eth_block_topic"
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