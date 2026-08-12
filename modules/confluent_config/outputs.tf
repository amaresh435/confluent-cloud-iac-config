output "cluster_ids" {
  description = "Kafka cluster IDs, keyed by input environment key."
  value       = { for key, cluster in confluent_kafka_cluster.gcp_dedicated : key => cluster.id }
}

output "cluster_bootstrap_endpoints" {
  description = "SASL_SSL bootstrap endpoints, keyed by input environment key."
  value       = { for key, cluster in confluent_kafka_cluster.gcp_dedicated : key => cluster.bootstrap_endpoint }
}

output "environment_ids" {
  description = "Confluent environment IDs, keyed by input environment key."
  value       = { for key, environment in confluent_environment.main : key => environment.id }
}

output "service_account_ids" {
  description = "Confluent service account IDs, keyed by input environment key."
  value       = { for key, account in confluent_service_account.main : key => account.id }
}
