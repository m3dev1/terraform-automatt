variable "region" {
  description = "AWS Region"
  type        = string
  default     = "us-east-2"
}

variable "bucket_name" {
  description = "AWS S3 Bucket name"
  type        = string
  default     = "automatt-tf"
}

variable "domain_name" {
  description = "Domain name used for CloudFront"
  type        = string
  default     = "automatt.dev"
}

variable "tag_name" {
  description = "S3 tag name"
  type        = string
  default     = "AutoMatt"
}

variable "tag_env" {
  description = "S3 tag environment"
  type        = string
  default     = "Dev"
}

# CloudFlare Creds - See secrets.tf

variable "domain" {
  default = "automatt.dev"
}

# CloudFlare - AWS Certificate Manager
resource "cloudflare_record" "aws-cert-manager" {
  zone_id = var.zone_id
  name    = var.automatt-dev-acm-name
  value   = var.automatt-dev-acm-value
  type    = "CNAME"
  proxied = false
  comment = "Required for AWS Cert Manager"
}

# CloudFlare - CloudFront CNAME
resource "cloudflare_record" "cloudfront-root-cname" {
  zone_id = var.zone_id
  name    = "@"
  value   = aws_cloudfront_distribution.automatt-tf.domain_name
  type    = "CNAME"
  proxied = true
  comment = "Required for CloudFront"
}

resource "cloudflare_record" "cloudfront-www-cname" {
  zone_id = var.zone_id
  name    = "www"
  value   = aws_cloudfront_distribution.automatt-tf.domain_name
  type    = "CNAME"
  proxied = true
  comment = "Required for CloudFront"
}


# Website files
variable "website_files_path" {
  type    = string
  default = "/home/m3/dev/dimension/_site"
}


variable "cloudfront_origin_path" {
  default ="/_site"
}