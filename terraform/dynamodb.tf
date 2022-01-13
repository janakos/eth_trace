resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "EthTraces"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 100
  hash_key       = "traceHash"
  range_key      = "blockNumber"


  attribute {
    name = "traceHash"
    type = "S"
  }
  attribute {
    name = "blockNumber"
    type = "N"
  }

  tags = {
    Name        = "dynamodb-table"
    Environment = "dev"
  }
}