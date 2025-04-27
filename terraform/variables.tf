variable "backend_bucket" {
  type        = string
  description = "S3 bucket for Terraform state"
}

variable "backend_key" {
  type        = string
  description = "Path/key in S3 bucket for state file"
}

variable "backend_region" {
  type        = string
  description = "AWS region for the S3 backend"
  default     = "us-east-1"
}

variable "environment" {
  type        = string
  description = "Deployment environment (main | PR-<id>)"
}
