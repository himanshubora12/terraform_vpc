provider "aws" {
  version = "~> 3.0"
  region = "ap-south-1"
  access_key = "XXXXXXXXXXXXXXX"
  secret_key = "XXXXXXXXXXXXXXXXXXXXXXXXXXX"
}

################ for AZs


data "aws_availability_zones" "available" {}

