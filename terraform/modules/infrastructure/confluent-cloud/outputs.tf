output "cluster_id" {
  value       = confluent_kafka_cluster.this.id
  description = "The Confluent Cloud Kafka cluster ID"
}
