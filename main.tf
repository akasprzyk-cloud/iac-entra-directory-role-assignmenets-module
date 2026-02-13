terraform {
  required_version = ">= 1.5"

  required_providers {
    azuread = {
      source  = "hashicorp/azuread"
      version = "~> 2.50"
    }
  }
}

resource "azuread_group" "groups" {
  for_each = local.role_assignments_map

  display_name       = each.value.group_name
  prevent_duplicate_names = false
  mail_enabled            = false
  security_enabled        = true
  assignable_to_role      = true
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

  role_id             = azuread_directory_role.roles[each.key].object_id
  principal_object_id = azuread_group.groups[each.key].object_id
}

resource "azuread_directory_role_eligibility_schedule_request" "eligible" {
  for_each = {
    for k, v in local.role_assignments_map :
    k => v if v.pim_enabled == "true"
  }

  role_definition_id = azuread_directory_role.roles[each.key].template_id
  principal_id       = azuread_group.groups[each.key].object_id
  directory_scope_id = "/"
  justification      = "PIM role assignment from Terraform"
}