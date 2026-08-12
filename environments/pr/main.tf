locals {
  env_name                    = "pr"
  prod_name                   = "fisher"
  resource_prefix             = join("-", [local.prod_name, local.env_name])
  gcp_project_id              = "vidya-00001"
  env_location                = "us-central1"
  tfm_sa_confluent_api_key    = data.google_secret_manager_secret_version.tfm_confluent_api_key.secret_data
  tfm_sa_confluent_api_secret = data.google_secret_manager_secret_version.tfm_confluent_api_secret.secret_data
  confluent_cltr_name         = [join("-", [local.resource_prefix])]
  secret_service_accounts     = ["terraform@vidya-00001.iam.gserviceaccount.com"]

  labels = {
    environment = local.env_name
    managed_by  = "terraform"
  }
}

module "confluent_config" {
  source = "../../modules/confluent_config"

  env_name                    = local.env_name
  prod_name                   = local.prod_name
  gcp_project                 = local.gcp_project_id
  region                      = local.env_location
  resource_prefix             = local.resource_prefix
  labels                      = local.labels
  tfm_sa_confluent_api_key    = local.tfm_sa_confluent_api_key
  tfm_sa_confluent_api_secret = local.tfm_sa_confluent_api_secret
  deletion_protection         = false
  confluent_cltr_name         = local.confluent_cltr_name
  secret_service_accounts     = local.secret_service_accounts
}
