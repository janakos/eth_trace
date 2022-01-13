resource "aws_dynamodb_table" "dynamodb-table" {
  name           = "EthTraces"
  billing_mode   = "PROVISIONED"
  read_capacity  = 20
  write_capacity = 20
  hash_key       = "BlockNumber"

  attribute {
    name = "BlockNumber"
    type = "N"
  }

  ttl {
    attribute_name = "TimeToExist"
    enabled        = false
  }

  tags = {
    Name        = "dynamodb-table"
    Environment = "dev"
  }
}