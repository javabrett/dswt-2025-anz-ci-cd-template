terraform {
  required_version = ">= 1.11.4"

  backend "s3" {
    bucket = var.backend_bucket
    key    = var.backend_key
    region = var.backend_region
  }
}
