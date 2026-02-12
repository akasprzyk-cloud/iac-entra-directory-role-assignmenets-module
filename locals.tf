locals {
  roles = csvdecode(file(var.directory_roles_csv_path))

  role_assignments_map = {
    for ra in local.roles :
    "${ra.group_name}-${ra.role_name}" => ra
  }
}
