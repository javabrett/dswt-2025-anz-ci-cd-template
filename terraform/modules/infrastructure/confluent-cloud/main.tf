terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.25.0"
    }
  }
}

provider "confluent" {
  # pick up credentials from env or a dedicated Confluent Cloud CLI login
}

resource "confluent_kafka_cluster" "this" {
  display_name = "${var.environment}-cluster"
}
