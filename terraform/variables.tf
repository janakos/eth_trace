variable "aws_region" {
  description = "AWS region for all resources."

  type    = string
  default = "us-east-2"
}

variable "assume_role_path" {
  description = "Assume role path"

  type    = string
  default = "./policies/assume_role_policy.json"
}


