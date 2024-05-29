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

variable "domain" {
  description = "Apex domain name"
  type        = string
  default     = "automatt.dev"
}

# Website files
variable "website_files_path" {
  description = "Path to website files to be uploaded"
  type        = string
  default     = "/home/m3/dev/dimension/_site"
}

variable "cloudfront_origin_path" {
  description = "Path to upload files to in S3"
  type        = string
  default     = "/_site"
}