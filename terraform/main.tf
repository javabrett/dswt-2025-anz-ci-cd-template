provider "aws" {
  region = var.backend_region
}

module "confluent_cloud" {
  source      = "modules/infrastructure/confluent-cloud"
  environment = var.environment
}
