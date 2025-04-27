terraform {
  required_version = ">= 1.11.4"

  required_providers {
    confluent = {
      source = "confluentinc/confluent"
      version = "2.25.0"
    }
    aws = {
      source = "hashicorp/aws"
      version = "5.96.0"
    }
  }

  backend "s3" {}
}

provider "aws" {
  region = "ap-southeast-2"
}

provider "confluent" {
  cloud_api_key    = var.confluent_cloud_api_key
  cloud_api_secret = var.confluent_cloud_api_secret
}

module "confluent_cloud" {
  source      = "./modules/infrastructure/confluent-cloud"
  environment = var.environment
}
