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
