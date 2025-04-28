resource "confluent_kafka_topic" "topic1" {
  kafka_cluster {
    id = confluent_kafka_cluster.this.id
  }
  topic_name    = "topic1"
  rest_endpoint = confluent_kafka_cluster.this.rest_endpoint
  credentials {
    key    = confluent_api_key.this.id
    secret = confluent_api_key.this.secret
  }
}

resource "confluent_schema" "topic1" {
  schema_registry_cluster {
    id = data.confluent_schema_registry_cluster.this.id
  }
  rest_endpoint = data.confluent_schema_registry_cluster.this.rest_endpoint
  # https://developer.confluent.io/learn-kafka/schema-registry/schema-subjects/#topicnamestrategy
  subject_name = "${confluent_kafka_topic.topic1.topic_name}-value"
  format       = "AVRO"
  schema       = file("./modules/infrastructure/confluent-cloud/schemas/avro/topic1.avsc")
  skip_validation_during_plan = true
  credentials {
    key    = confluent_api_key.sr.id
    secret = confluent_api_key.sr.secret
  }
}
