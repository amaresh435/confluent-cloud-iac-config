locals {
  environment_names = var.env_name != null || var.prod_name != null ? {
    development = coalesce(var.env_name, "development")
    #production  = coalesce(var.prod_name, "production")
  } : var.environment_names

  gcp_region = coalesce(var.region, var.gcp_region)

  cluster_display_name = var.resource_prefix == null ? var.cluster_display_name : "${var.resource_prefix}-gcp-dedicated"
}

resource "confluent_environment" "this" {
  for_each = local.environment_names

  display_name = each.value
}

# A Dedicated GCP cluster at one CKU must use SINGLE_ZONE availability.
resource "confluent_kafka_cluster" "gcp_dedicated" {
  display_name        = local.cluster_display_name
  availability        = "SINGLE_ZONE"
  cloud               = "GCP"
  region              = local.gcp_region
  deletion_protection = var.deletion_protection

  dedicated {
    cku = 1
  }

  environment {
    id = confluent_environment.this[var.cluster_environment_key].id
  }

  dynamic "network" {
    for_each = var.network_id == null ? [] : [var.network_id]
    content {
      id = network.value
    }
  }
}
