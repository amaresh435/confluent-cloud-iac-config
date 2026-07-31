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
}
