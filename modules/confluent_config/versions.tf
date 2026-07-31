terraform {
  required_version = ">= 1.9.7"

  required_providers {
    confluent = {
      source  = "confluentinc/confluent"
      version = "~> 2.78"
    }
  }
}
