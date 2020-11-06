provider "aws" {
  version = "~> 3.0"
  region = "ap-south-1"
  access_key = "AKIAU5XGRDZT2YPCCHOE"
  secret_key = "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"
}

################ for AZs


data "aws_availability_zones" "available" {}

