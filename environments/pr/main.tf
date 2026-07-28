locals {
  env_name                = "pr"
  prod_name               = "fish"
  resource_prefix         = join("-", [local.prod_name, local.env_name])
  gcp_project_id           = "vidya-00001"
  env_location            = "us-central1"
  labels = {
    environment = local.env_name
    managed_by  = "terraform"
  }

  module "google_gke_cluster" {
    source = "../../modules/gke_cluster"

    env_name        = local.env_name
    prod_name       = local.prod_name
    project_id      = local.gcp_project_id
    region          = local.env_location
    resource_prefix = local.resource_prefix
    labels          = local.labels
}
