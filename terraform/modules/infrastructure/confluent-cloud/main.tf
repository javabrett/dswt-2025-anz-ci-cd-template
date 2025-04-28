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

  stream_governance {
    package = "ADVANCED"
  }
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

resource "confluent_service_account" "this" {
  display_name = "${var.environment}-cloud-cluster-admin"
  description  = "${var.environment}-CloudClusterAdmin"
}

resource "confluent_role_binding" "this" {
  principal   = "User:${confluent_service_account.this.id}"
  role_name   = "CloudClusterAdmin"
  crn_pattern = confluent_kafka_cluster.this.rbac_crn
}

resource "confluent_api_key" "this" {
  display_name = "${var.environment}-cloud-cluster-admin-api-key"
  description  = "${var.environment}-CloudClusterAdmin API Key"
  owner {
    id          = confluent_service_account.this.id
    api_version = confluent_service_account.this.api_version
    kind        = confluent_service_account.this.kind
  }

  managed_resource {
    id          = confluent_kafka_cluster.this.id
    api_version = confluent_kafka_cluster.this.api_version
    kind        = confluent_kafka_cluster.this.kind

    environment {
      id = confluent_environment.this.id
    }
  }

  # The goal is to ensure that confluent_role_binding.app-manager-kafka-cluster-admin is created before
  # confluent_api_key.app-manager-kafka-api-key is used to create instances of
  # confluent_kafka_topic, confluent_kafka_acl resources.

  # 'depends_on' meta-argument is specified in confluent_api_key.app-manager-kafka-api-key to avoid having
  # multiple copies of this definition in the configuration which would happen if we specify it in
  # confluent_kafka_topic, confluent_kafka_acl resources instead.
  depends_on = [
    confluent_role_binding.this
  ]
}

resource "confluent_kafka_topic" "topic0" {
  kafka_cluster {
    id = confluent_kafka_cluster.this.id
  }
  topic_name    = "topic0"
  rest_endpoint = confluent_kafka_cluster.this.rest_endpoint
  credentials {
    key    = confluent_api_key.this.id
    secret = confluent_api_key.this.secret
  }
}
