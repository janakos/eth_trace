variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-2"
}

variable "assume_role_path" {
  description = "File path for assume role policy"

  type    = string
  default = "./policies/lambda_api_policy.json"
}


