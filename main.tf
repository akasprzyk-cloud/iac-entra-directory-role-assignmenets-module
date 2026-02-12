terraform {
  required_version = ">= 1.5"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50"
    }
  }
}

data "azuread_group" "groups" {
  for_each     = local.role_assignments_map
  display_name = each.value.group_name
}

resource "azuread_directory_role" "roles" {
  for_each     = local.role_assignments_map
  display_name = each.value.role_name
}

resource "azuread_directory_role_assignment" "active" {
  for_each = {
    for k, v in local.role_assignments_map :
    k => v if v.pim_enabled == "false"
  }

  role_id             = azuread_directory_role.roles[each.key].id
  principal_object_id = data.azuread_group.groups[each.key].id
}

resource "azuread_directory_role_assignment" "eligible" {
  for_each = {
    for k, v in local.role_assignments_map :
    k => v if v.pim_enabled == "true"
  }

  role_id             = azuread_directory_role.roles[each.key].id
  principal_object_id = data.azuread_group.groups[each.key].id
}
