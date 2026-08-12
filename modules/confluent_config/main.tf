locals {
  environment_names = var.env_name != null || var.prod_name != null ? {
    development = coalesce(var.env_name, "development")
    #production  = coalesce(var.prod_name, "production")
  } : var.environment_names

  gcp_region      = coalesce(var.region, var.gcp_region)
  resource_prefix = join("-", [var.prod_name, var.env_name])

}

data "confluent_organization" "main" {}

resource "confluent_environment" "main" {
  display_name = join("-", [var.resource_prefix, "env"])

  stream_governance {
    package = var.stream_governance
  }
}

# A Dedicated GCP cluster at one CKU must use SINGLE_ZONE availability.
resource "confluent_kafka_cluster" "gcp_dedicated" {
  for_each = toset(var.confluent_cltr_name)

  display_name        = join("-", [var.resource_prefix, each.key])
  availability        = "SINGLE_ZONE"
  cloud               = "GCP"
  region              = local.gcp_region
  deletion_protection = var.deletion_protection

  dedicated {
    cku = 1
  }

  environment {
    id = confluent_environment.main.id
  }

  dynamic "network" {
    for_each = var.network_id == null ? [] : [var.network_id]
    content {
      id = network.value
    }
  }
}

resource "confluent_service_account" "main" {
  display_name = join("-", [local.resource_prefix, "env", "tf", "common", "svcacct"])
  description  = "Terraform deployment for ${local.resource_prefix} environments"
}

resource "confluent_role_binding" "main" {
  for_each = toset(var.confluent_cltr_name)

  principal   = "User:${confluent_service_account.main.id}"
  role_name   = "EnvironmentAdmin"
  crn_pattern = confluent_environment.main.resource_name
}

resource "confluent_role_binding" "account_admin" {
  principal   = "User:${confluent_service_account.main.id}"
  role_name   = "AccountAdmin"
  crn_pattern = data.confluent_organization.main.resource_name
}

resource "confluent_api_key" "main" {
  display_name = join("-", [local.resource_prefix, "tf", "env", "apikey"])
  description  = "Cloud API key owned by ${local.resource_prefix} service account"

  owner {
    id          = confluent_service_account.main.id
    api_version = confluent_service_account.main.api_version
    kind        = confluent_service_account.main.kind
  }

  lifecycle {
    prevent_destroy = true
  }

  depends_on = [confluent_role_binding.main]
}

resource "google_secret_manager_secret" "apikey_key" {
  project   = var.gcp_project
  secret_id = join("-", ["tf", "confluent", "cloud", local.resource_prefix, "common", "api", "key"])
  labels    = var.labels

  replication {
    auto {}
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_secret_manager_secret_version" "apikey_key" {
  secret      = google_secret_manager_secret.apikey_key.id
  secret_data = confluent_api_key.main.id
}

resource "google_secret_manager_secret" "apikey_secret" {
  project   = var.gcp_project
  secret_id = join("-", ["tf", "confluent", "cloud", local.resource_prefix, "common", "api", "secret"])
  labels    = var.labels

  replication {
    auto {}
  }

  lifecycle {
    prevent_destroy = true
  }
}

resource "google_secret_manager_secret_version" "apikey_secret" {
  secret      = google_secret_manager_secret.apikey_secret.id
  secret_data = confluent_api_key.main.secret
}

resource "google_secret_manager_secret_iam_member" "apikey_key_viewer" {
  for_each = toset(var.secret_service_accounts)

  project   = var.gcp_project
  secret_id = google_secret_manager_secret.apikey_key.id
  role      = "roles/secretmanager.viewer"
  member    = format("serviceAccount:%s", each.value)
}

resource "google_secret_manager_secret_iam_member" "apikey_key_accessor" {
  for_each = toset(var.secret_service_accounts)

  project   = var.gcp_project
  secret_id = google_secret_manager_secret.apikey_key.id
  role      = "roles/secretmanager.secretAccessor"
  member    = format("serviceAccount:%s", each.value)
}

resource "google_secret_manager_secret_iam_member" "apikey_secret_viewer" {
  for_each = toset(var.secret_service_accounts)

  project   = var.gcp_project
  secret_id = google_secret_manager_secret.apikey_secret.id
  role      = "roles/secretmanager.viewer"
  member    = format("serviceAccount:%s", each.value)
}

resource "google_secret_manager_secret_iam_member" "apikey_secret_accessor" {
  for_each = toset(var.secret_service_accounts)

  project   = var.gcp_project
  secret_id = google_secret_manager_secret.apikey_secret.id
  role      = "roles/secretmanager.secretAccessor"
  member    = format("serviceAccount:%s", each.value)
}
