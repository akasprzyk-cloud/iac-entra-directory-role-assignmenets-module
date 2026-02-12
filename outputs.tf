output "active_assignments" {
  description = "Map of active role assignment IDs."
  value = {
    for k, v in azuread_directory_role_assignment.active :
    k => v.id
  }
}
