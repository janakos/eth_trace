# Create bucket
resource "random_pet" "lambda_bucket_name" {
  prefix = "terraform"
  length = 4
}

resource "aws_s3_bucket" "lambda_bucket" {
  bucket = random_pet.lambda_bucket_name.id

  acl           = "private"
  force_destroy = true
}

# Lambda
data "archive_file" "zip_store_traces" {
  type = "zip"

  source_file  = "../store_traces.py"
  output_path = "../zips/store_traces.zip"
}

data "archive_file" "zip_store_traces_packages" {
  type = "zip"

  source_file  = "../store_traces.py"
  output_path = "../zips/store_traces.zip"
}

resource "aws_s3_bucket_object" "upload_lambda_store_traces" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "store_traces.zip"
  source = data.archive_file.zip_store_traces.output_path

  etag = filemd5(data.archive_file.zip_store_traces.output_path)
}

# Lambda Controller
data "archive_file" "zip_store_traces_controller" {
  type = "zip"

  source_file  = "../store_traces_controller.py"
  output_path = "../zips/store_traces_controller.zip"
}

resource "aws_s3_bucket_object" "upload_lambda_store_traces_controller" {
  bucket = aws_s3_bucket.lambda_bucket.id

  key    = "store_traces_controller.zip"
  source = data.archive_file.zip_store_traces_controller.output_path

  etag = filemd5(data.archive_file.zip_store_traces_controller.output_path)
}