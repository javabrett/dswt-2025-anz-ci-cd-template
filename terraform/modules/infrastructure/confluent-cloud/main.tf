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

data "confluent_schema_registry_cluster" "this" {
  environment {
    id = confluent_environment.this.id
  }

  depends_on = [
    confluent_kafka_cluster.this
  ]
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

resource "confluent_role_binding" "data-steward" {
  principal   = "User:${confluent_service_account.this.id}"
  role_name   = "DataSteward"
  crn_pattern = confluent_environment.this.resource_name
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

  depends_on = [
    confluent_role_binding.this
  ]
}

resource "confluent_api_key" "sr" {
  display_name = "${var.environment}-schema-registry-api-key"
  description  = "${var.environment}-Schema Registry API Key"
  owner {
    id          = confluent_service_account.this.id
    api_version = confluent_service_account.this.api_version
    kind        = confluent_service_account.this.kind
  }

  managed_resource {
    id          = data.confluent_schema_registry_cluster.this.id
    api_version = data.confluent_schema_registry_cluster.this.api_version
    kind        = data.confluent_schema_registry_cluster.this.kind

    environment {
      id = confluent_environment.this.id
    }
  }

  depends_on = [
    confluent_role_binding.data-steward
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
