terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region = "us-east-2"
}

resource "aws_s3_bucket" "automatt-tf" {
  bucket = "automatt-tf"

  tags = {
    Name        = "AutoMatt Terraform"
    Environment = "Dev"
  }
}

resource "aws_s3_bucket_versioning" "automatt-tf" {
  bucket = aws_s3_bucket.automatt-tf.id
  versioning_configuration {
    status = "Enabled"
  }
}