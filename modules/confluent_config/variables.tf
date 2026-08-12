variable "environment_names" {
  description = "Exactly two Confluent Cloud environments, keyed by stable Terraform identifiers."
  type        = map(string)

  default = {
    development = "development"
    production  = "production"
  }

  validation {
    condition     = length(var.environment_names) == 2
    error_message = "Exactly two Confluent environments must be supplied."
  }
}

# Compatibility inputs for the calling configuration. When either name is set,
# they take precedence over environment_names for the two managed environments.
variable "env_name" {
  description = "Development Confluent environment display name."
  type        = string
  default     = null
  nullable    = true
}

variable "prod_name" {
  description = "Production Confluent environment display name."
  type        = string
  default     = null
  nullable    = true
}

variable "gcp_project" {
  description = "GCP project ID retained for compatibility with the root configuration. Confluent-managed GCP Kafka clusters do not use it."
  type        = string
  default     = "vidya-00001"
}

variable "region" {
  description = "Alias for gcp_region. When set, it takes precedence."
  type        = string
  default     = null
  nullable    = true
}

variable "resource_prefix" {
  description = "Optional prefix used for the GCP Dedicated Kafka cluster display name."
  type        = string
  default     = null
  nullable    = true
}

variable "labels" {
  description = "Labels retained for compatibility with the root configuration. Confluent Cloud environment and Kafka cluster resources do not support GCP labels."
  type        = map(string)
  default     = {}
}

variable "tfm_sa_confluent_api_key" {
  description = "Confluent Cloud API key retained for compatibility. Configure it on the root Confluent provider or with CONFLUENT_CLOUD_API_KEY."
  type        = string
  default     = null
  nullable    = true
  sensitive   = true
}

variable "tfm_sa_confluent_api_secret" {
  description = "Confluent Cloud API secret retained for compatibility. Configure it on the root Confluent provider or with CONFLUENT_CLOUD_API_SECRET."
  type        = string
  default     = null
  nullable    = true
  sensitive   = true
}

variable "cluster_environment_key" {
  description = "Key from environment_names in which to create the Dedicated GCP Kafka cluster."
  type        = string
  default     = "development"
}

variable "confluent_cltr_name" {
  description = "Display name of the Dedicated GCP Kafka cluster."
  type        = list(string)
  default     = ["development-gcp-dedicated"]
}

variable "gcp_region" {
  description = "Confluent Cloud GCP region for the Kafka cluster."
  type        = string
  default     = "us-central1"
}

variable "network_id" {
  description = "Optional existing Confluent private network ID for the Kafka cluster."
  type        = string
  default     = null
  nullable    = true
}

variable "deletion_protection" {
  description = "Prevents deletion of the Dedicated Kafka cluster unless set to false."
  type        = bool
  default     = true
}

variable "stream_governance" {
  type        = string
  description = "Optional governance mode: ESSENTIALS or ADVANCED."
  default     = "ADVANCED"

  validation {
    condition     = contains(["ESSENTIALS", "ADVANCED"], var.stream_governance)
    error_message = "Value must be one of: ESSENTIALS, ADVANCED."
  }
}

variable "cltr_name" {
  type        = list(string)
  default     = []
  description = "Suffixes appended to resource names."
}

variable "secret_service_accounts" {
  type        = list(string)
  description = "Service accounts that should have access to the API key secret."
  default     = []
}
