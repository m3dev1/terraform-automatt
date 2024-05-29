# terraform-automatt
AutoMatt.sh infrastructure created using Infrastructure as Code with Terraform.

## Introduction
This project was created to put my Terraform learning into practice by converting my portfolio website, [AutoMatt.sh](https://automatt.sh) hosted in AWS, to Infrastructure as Code using HashiCorp Terraform.

### See it live
- [AutoMatt.dev](https://automatt.dev) - Deployed using Terraform
- [Code: AutoMatt.dev](https://github.com/m3dev1/dimension)

### The inspiration
- [Automatt.sh](https://automatt.sh) - Deployed using GitHub Actions
- [Code: AutoMatt.sh](https://github.com/m3dev1/terraform-automatt)

## Features
- AWS S3
  - Bucket versioning
  - Uploads files to S3 bucket
  - ACLs to block public access
  - S3 bucket policy using Origin Access Control
- AWS CloudFront Distribution
  - Error pages (404, 403)
  - Cache policies
- AWS CloudFront Functions
  - Redirect handling for resume
- AWS Origin Access Control
  - S3 bucket policy
- AWS Certificate Manager
  - SSL/TLS certificates

## Prerequisites
- Static site generated files in `/home/m3/dev/dimension/_site`, or update path in `variables.tf`.
- AWS CLI to configure AWS credentials using `aws configure`.
- Terraform to execute the code using `terraform plan` and `terraform apply`.

## Setup
```sh
# Clone repo.
git clone https://github.com/m3dev1/terraform-automatt.git

# Replace placeholder text with actual values.
vim terraform-automatt/secrets.tf

# Configure site path directory
vim terraform-automatt/variables.tf

# See the plan of what Terraform will do.
terraform plan

# If plan looks good, approve the apply action.
terraform apply --auto-approve
```

> [!IMPORTANT]
> The entire process running from scratch will take about 15 minutes or so for everything to come online. This is primarily due to the time that it takes to configure CloudFront and upload the files to S3.