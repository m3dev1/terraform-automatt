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
  region = var.region
}

resource "aws_s3_bucket" "automatt-tf" {
  bucket = var.bucket_name

  tags = {
    Name        = "automatt-tf"
    Environment = "dev"
  }
}

resource "aws_s3_bucket_versioning" "automatt-tf" {
  bucket = aws_s3_bucket.automatt-tf.id

  versioning_configuration {
    status = "Enabled"
  }
}