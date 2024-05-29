provider "cloudflare" {
  api_token = "REPLACE_WITH_CLOUDFLARE_TOKEN"
}

variable "zone_id" {
  default   = "REPLACE_WITH_CLOUDFLARE_ZONE_ID"
  sensitive = true
}

variable "account_id" {
  default   = "REPLACE_WITH_CLOUDFLARE_ACCOUNT_ID"
  sensitive = true
}

variable "automatt-dev-acm-name" {
  default   = "REPLACE_WITH_AWS_ACM_NAME"
  sensitive = true
}

variable "automatt-dev-acm-value" {
  default   = "REPLACE_WITH_AWS_ACM_VALUE"
  sensitive = true
}