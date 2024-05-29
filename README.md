# terraform-automatt
AutoMatt.sh infrastructure created using Infrastructure as Code with Terraform.

## Introduction
This project was created to put my Terraform learning into practicce by converting my portfolio website, [AutoMatt.sh](https://automatt.sh) created using [Eleventy (11ty)](https://11ty.dev) and hosted in AWS, to Infrastructure as Code using HashiCorp Terraform.

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
- AWS CLI to run `aws configure`
- Terraform
- Static site generated files in `/home/m3/dev/dimension/_site`

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

> [!warning] Warning
> The entire process running from scratch will take about 15 minutes or so for everything to come online. This is primarily due to the time that it takes to configure CloudFront and upload the files to S3.