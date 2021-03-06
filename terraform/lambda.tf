# Set up lambda to read block traces
resource "aws_lambda_function" "store_traces" {
  function_name = "store_traces"

  s3_bucket = aws_s3_bucket.lambda_bucket.id
  s3_key    = aws_s3_bucket_object.upload_lambda_store_traces.key

  runtime = "python3.8"
  layers = [aws_lambda_layer_version.store_traces_layer.arn]
  handler = "store_traces.handler"
  timeout = 60

  source_code_hash = data.archive_file.zip_store_traces.output_base64sha256

  role = aws_iam_role.role_for_LDC.arn
}

# Add layer for pythons request library
resource "aws_lambda_layer_version" "store_traces_layer" {
  filename   = "../zips/layer_store_traces.zip"
  layer_name = "store_traces_layer"

  compatible_runtimes = ["python3.8"]
}

# Cloudwatch
resource "aws_cloudwatch_log_group" "store_traces_cloudwatch" {
  name = "/aws/lambda/${aws_lambda_function.store_traces.function_name}"

  retention_in_days = 30
}

# Permissions
resource "aws_iam_role_policy" "lambda_policy" {
  name = "lambda_policy"
  role = aws_iam_role.role_for_LDC.id

  policy = file("./policies/lambda_policy.json")
}


resource "aws_iam_role" "role_for_LDC" {
  name = "lambda_role"

  assume_role_policy = file(var.assume_role_path)

}
