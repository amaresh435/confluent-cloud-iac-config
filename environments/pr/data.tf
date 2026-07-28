data "google_secret_manager_secret_version" "tfm_confluent_api_key" {
  project = local.gcp_project_id
  secret  = "terraform-confluent-cloud-api-key"
  version = "latest"
}

data "google_secret_manager_secret_version" "tfm_confluent_api_secret" {
  project = local.gcp_project_id
  secret  = "terraform-confluent-cloud-api-secret"
  version = "latest"
}
