terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.51"
    }

    cloudflare = {
      source  = "cloudflare/cloudflare"
      version = "~> 4"
    }
  }

  required_version = ">= 1.8.4"
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

# AWS Cert Manager
resource "aws_acm_certificate" "automatt-tf" {
  domain_name       = var.domain_name
  validation_method = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

