# Confluent configuration module

Creates exactly two Confluent Cloud environments and one Dedicated Kafka cluster on GCP. The cluster uses `SINGLE_ZONE` availability and `cku = 1`.

Configure the Confluent provider in the calling root module; do not place API credentials in this module.

```hcl
provider "confluent" {}

module "confluent_config" {
  source = "./modules/confluent_config"

  environment_names = {
    development = "development"
    production  = "production"
  }

  cluster_environment_key = "development"
  cluster_display_name    = "development-gcp-dedicated"
  gcp_region              = "us-central1"
}
```

Authenticate before running Terraform:

```powershell
$env:CONFLUENT_CLOUD_API_KEY = "your-admin-api-key"
$env:CONFLUENT_CLOUD_API_SECRET = "your-admin-api-secret"
```

Set `network_id` only when the cluster must be attached to an existing Confluent private network. Dedicated GCP cluster provisioning can take approximately 25 minutes or longer.

For compatibility with existing root configurations, the module also accepts `env_name`, `prod_name`, `region`, `resource_prefix`, `project_id`, `labels`, `tfm_sa_confluent_api_key`, and `tfm_sa_confluent_api_secret`. `env_name` and `prod_name` override the default environment names, and `region` overrides `gcp_region`. Configure API credentials on the root `confluent` provider or through `CONFLUENT_CLOUD_API_KEY` and `CONFLUENT_CLOUD_API_SECRET`; do not put them in Terraform state.


