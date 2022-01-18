resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "EthTraces"
  billing_mode   = "PAY_PER_REQUEST"
  hash_key       = "blockNumber"
  range_key      = "traceHash"


  attribute {
    name = "blockNumber"
    type = "N"
  }

  attribute {
    name = "traceHash"
    type = "S"
  }

  tags = {
    Name        = "dynamodb-table"
    Environment = "dev"
  }
}