terraform {
  required_version = ">=1.9.7"

  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 2.78"
    }

    google = {
    source = "hashicorp/google"
    version = ">=6.0"
    }
  }
}

provider "confluent" {
  # Credentials come from CONFLUENT_CLOUD_API_KEY and CONFLUENT_CLOUD_API_SECRET.
  cloud_api_key    = local.tfm_sa_confluent_api_key    # optionally use CONFLUENT_CLOUD_API_KEY env var
  cloud_api_secret = local.tfm_sa_confluent_api_secret # optionally use CONFLUENT_CLOUD_API_SECRET env var
}
