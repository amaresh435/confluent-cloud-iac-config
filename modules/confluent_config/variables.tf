variable "environments" {
  description = "Environments and their Dedicated GCP Kafka clusters. Each map key is a stable Terraform identifier."
  type = map(object({
    display_name      = string
    stream_governance = optional(string)
    cluster = object({
      display_name        = string
      region              = string
      availability        = string
      cku                 = number
      network_id          = optional(string)
      deletion_protection = optional(bool, true)
    })
  }))

  validation {
    condition = alltrue([
      for environment in values(var.environments) :
      contains(["SINGLE_ZONE", "MULTI_ZONE"], environment.cluster.availability)
    ])
    error_message = "Dedicated cluster availability must be SINGLE_ZONE or MULTI_ZONE."
  }

  validation {
    condition = alltrue([
      for environment in values(var.environments) :
      environment.cluster.availability != "MULTI_ZONE" || environment.cluster.cku >= 2
    ])
    error_message = "MULTI_ZONE Dedicated clusters require at least 2 CKUs."
  }
}

variable "service_accounts" {
  description = "Service accounts to create, keyed by a stable Terraform identifier."
  type = map(object({
    display_name = string
    description  = optional(string)
  }))
  default = {}
}

variable "users" {
  description = "Existing Confluent Cloud users, keyed by a stable Terraform identifier and looked up by email."
  type        = map(string)
  default     = {}
}

variable "role_bindings" {
  description = "RBAC bindings. principal_type is service_account or user; scope is environment, cluster, or a custom CRN."
  type = map(object({
    principal_type  = string
    principal_key   = string
    role_name       = string
    scope           = string
    environment_key = optional(string)
    crn_pattern     = optional(string)
  }))
  default = {}

  validation {
    condition = alltrue([
      for binding in values(var.role_bindings) :
      contains(["service_account", "user"], binding.principal_type)
    ])
    error_message = "role_bindings.principal_type must be service_account or user."
  }

  validation {
    condition = alltrue([
      for binding in values(var.role_bindings) :
      contains(["environment", "cluster", "custom"], binding.scope)
    ])
    error_message = "role_bindings.scope must be environment, cluster, or custom."
  }
}
