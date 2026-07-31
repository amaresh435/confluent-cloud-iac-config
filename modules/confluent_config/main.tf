resource "confluent_environment" "prof_eng" {
  for_each = var.environments

  display_name = each.value.display_name

  dynamic "stream_governance" {
    for_each = each.value.stream_governance == null ? [] : [each.value.stream_governance]
    content {
      package = stream_governance.value
    }
  }

}

resource "confluent_kafka_cluster" "prof_eng" {
  for_each = var.environments

  display_name        = each.value.cluster.display_name
  availability        = each.value.cluster.availability
  cloud               = "GCP"
  region              = each.value.cluster.region
  deletion_protection = each.value.cluster.deletion_protection

  dedicated {
    cku = each.value.cluster.cku
  }

  environment {
    id = confluent_environment.prof_eng[each.key].id
  }

  dynamic "network" {
    for_each = each.value.cluster.network_id == null ? [] : [each.value.cluster.network_id]
    content {
      id = network.value
    }
  }
}

resource "confluent_service_account" "prof_eng" {
  for_each = var.service_accounts

  display_name = each.value.display_name
  description  = each.value.description
}

data "confluent_user" "prof_eng" {
  for_each = var.users

  email = each.value
}

locals {
  role_bindings = {
    for key, binding in var.role_bindings : key => merge(binding, {
      principal = binding.principal_type == "service_account" ? "User:${confluent_service_account.prof_eng[binding.principal_key].id}" : "User:${data.confluent_user.prof_eng[binding.principal_key].id}"
      crn_pattern = binding.scope == "environment" ? confluent_environment.prof_eng[binding.environment_key].resource_name : (
        binding.scope == "cluster" ? confluent_kafka_cluster.prof_eng[binding.environment_key].rbac_crn : binding.crn_pattern
      )
    })
  }
}

resource "confluent_role_binding" "prof_eng" {
  for_each = local.role_bindings

  principal   = each.value.principal
  role_name   = each.value.role_name
  crn_pattern = each.value.crn_pattern
}
