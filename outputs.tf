output "groups" {
  description = "Map of created groups."
  value = {
    for k, v in azuread_group.groups :
    k => {
      id           = v.id
      object_id    = v.object_id
      display_name = v.display_name
    }
  }
}

output "active_assignments" {
  description = "Map of active role assignment IDs."
  value = {
    for k, v in azuread_directory_role_assignment.active :
    k => v.id
  }
}

output "eligible_assignments" {
  description = "Map of eligible role assignment IDs."
  value = {
    for k, v in azuread_directory_role_eligibility_schedule_request.eligible :
    k => v.id
  }
}
