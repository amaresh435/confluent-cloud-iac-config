locals {
  env_name                    = "pr"
  prod_name                   = "fisher"
  resource_prefix             = join("-", [local.prod_name, local.env_name])
  gcp_project_id              = "vidya-00001"
  env_location                = "us-central1"
  tfm_sa_confluent_api_key    = data.google_secret_manager_secret_version.tfm_confluent_api_key.secret_data
  tfm_sa_confluent_api_secret = data.google_secret_manager_secret_version.tfm_confluent_api_secret.secret_data

  labels = {
    environment = local.env_name
    managed_by  = "terraform"
  }
}

module "confluent_config" {
  source = "../../modules/confluent_config"

  env_name                    = local.env_name
  prod_name                   = local.prod_name
  project_id                  = local.gcp_project_id
  region                      = local.env_location
  resource_prefix             = local.resource_prefix
  labels                      = local.labels
  tfm_sa_confluent_api_key    = local.tfm_sa_confluent_api_key
  tfm_sa_confluent_api_secret = local.tfm_sa_confluent_api_secret
  deletion_protection         = local.deletion_protection
}
