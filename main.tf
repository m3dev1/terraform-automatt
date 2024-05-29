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

provider "aws" {
  alias  = "acm_provider"
  region = "us-east-1"
}

# S3 - Bucket
resource "aws_s3_bucket" "automatt-tf" {
  bucket = var.bucket_name

  tags = {
    Name        = "automatt-tf"
    Environment = "dev"
  }
}

# S3 - Bucket Versioning
resource "aws_s3_bucket_versioning" "automatt-tf" {
  bucket = aws_s3_bucket.automatt-tf.id

  versioning_configuration {
    status = "Enabled"
  }
}

# S3 - Bucket Policy - Defined from Origin Access Control
resource "aws_s3_bucket_policy" "automatt-tf_policy" {
  bucket = aws_s3_bucket.automatt-tf.id

  policy = jsonencode({
    "Version" : "2008-10-17",
    "Id" : "PolicyForCloudFrontPrivateContent",
    "Statement" : [
      {
        "Sid" : "AllowCloudFrontServicePrincipal",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "cloudfront.amazonaws.com"
        },
        "Action" : "s3:GetObject",
        "Resource" : "${aws_s3_bucket.automatt-tf.arn}/*",
        "Condition" : {
          "StringEquals" : {
            "AWS:SourceArn" : aws_cloudfront_distribution.automatt-tf.arn
          }
        }
      }
    ]
  })
}

# AWS Cert Manager
resource "aws_acm_certificate" "automatt-tf" {
  provider                  = aws.acm_provider
  domain_name               = var.domain_name
  subject_alternative_names = ["*.${var.domain_name}", ]
  validation_method         = "DNS"

  lifecycle {
    create_before_destroy = true
  }
}

# Origin Access Control
resource "aws_cloudfront_origin_access_control" "automatt-tf_oac" {
  name                              = "AutoMattOAC"
  origin_access_control_origin_type = "s3"
  signing_protocol                  = "sigv4"
  signing_behavior                  = "always"
}


# CloudFront Distribution
resource "aws_cloudfront_distribution" "automatt-tf" {
  origin {
    domain_name = aws_s3_bucket.automatt-tf.bucket_regional_domain_name
    origin_id   = "S3-${var.bucket_name}"
    origin_path = var.cloudfront_origin_path
    # origin_access_control_id = aws_cloudfront_origin_access_control.automatt-tf_oac.id
    origin_access_control_id = aws_cloudfront_origin_access_control.automatt-tf_oac.id

    # s3_origin_config {
    #   #   origin_access_identity = aws_cloudfront_origin_access_identity.automatt-tf.cloudfront_access_identity_path
    # #   origin_access_identity = aws_cloudfront_origin_access_control.automatt-tf_oac.id

    # }
  }

  comment             = "AutoMatt.dev CloudFront Distribution"
  enabled             = true
  is_ipv6_enabled     = true
  default_root_object = "index.html"
  price_class         = "PriceClass_100" # North America and Europe
  http_version        = "http2and3"

  aliases = [
    var.domain_name,
    "www.${var.domain_name}"
  ]

  default_cache_behavior {
    target_origin_id       = "S3-${var.bucket_name}"
    viewer_protocol_policy = "redirect-to-https"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized

    allowed_methods = ["GET", "HEAD"]
    cached_methods  = ["GET", "HEAD"]

    # forwarded_values {
    #   query_string = false
    #   cookies {
    #     forward = "none"
    #   }
    # }
  }

  ordered_cache_behavior {
    path_pattern           = "/resume*"
    viewer_protocol_policy = "redirect-to-https"
    allowed_methods        = ["GET", "HEAD"]
    cached_methods         = ["GET", "HEAD"]
    target_origin_id       = "S3-${var.bucket_name}"
    cache_policy_id        = "658327ea-f89d-4fab-a63d-7e88639e58f6" # Managed-CachingOptimized
    # target_origin_id = aws_s3_bucket.automatt-tf.bucket_regional_domain_name
    # forwarded_values {
    #   ### TODO - Look into this
    #   query_string = false
    #   cookies {
    #     forward = "none"
    #   }
    # }

    function_association {
      event_type   = "viewer-request"
      function_arn = aws_cloudfront_function.redirect-resume-function.arn
    }
  }

  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  viewer_certificate {
    acm_certificate_arn      = aws_acm_certificate.automatt-tf.arn
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }

  custom_error_response {
    error_code            = 403
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 300
  }

  custom_error_response {
    error_code            = 404
    response_code         = 404
    response_page_path    = "/404.html"
    error_caching_min_ttl = 300
  }
}

# CloudFront Redirect Function
resource "aws_cloudfront_function" "redirect-resume-function" {
  name    = "Redirect-Resume-Function"
  runtime = "cloudfront-js-2.0"
  publish = true

  code = <<-EOF
    function handler(event) {
        var request = event.request;
        var uri = request.uri;
        if (uri === '/resume') {
            request.uri = '/resume.html';
        }
        return request;
        }
    EOF
}

# S3 - Upload Files
resource "aws_s3_object" "website_files" {
  for_each = fileset(var.website_files_path, "**/*")
  bucket   = aws_s3_bucket.automatt-tf.id
  key      = "/_site/${each.key}"
  source   = "${var.website_files_path}/${each.value}"
  etag     = filemd5("${var.website_files_path}/${each.value}")

  content_type = lookup({
    "html" = "text/html",
    "css"  = "text/css",
    "js"   = "application/javascript",
    "png"  = "image/png",
    "jpg"  = "image/jpeg",
    "jpeg" = "image/jpeg",
    "gif"  = "image/gif",
    "svg"  = "image/svg+xml"
  }, split(".", each.value)[length(split(".", each.value)) - 1], "application/octet-stream")
}