terraform {
  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "2.25.0"
    }
  }
}

resource "confluent_environment" "this" {
  display_name = "${var.environment}-environment"
}

resource "confluent_kafka_cluster" "this" {
  display_name = "${var.environment}-cluster"
  cloud = "AWS"
  region = "ap-southeast-2"
  basic {}
  availability = "LOW"
  environment {
    id = confluent_environment.this.id
  }
}
