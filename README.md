# Entra directory role assignments (module)

This module creates Entra ID groups and assigns directory roles from a CSV file. Assignments can be either **active** (permanent) or **eligible** (PIM) based on the `pim_enabled` column. Groups are created with `assignable_to_role = true`.

## Inputs
- `directory_roles_csv_path` (string, required) – path to CSV with role assignments

## Usage
```
module "directory_role_assignments" {
  source = "git::https://github.com/<org>/<repo>.git?ref=v0.1.0"

  directory_roles_csv_path = "${path.module}/directory-roles.csv"
}
```

## CSV columns
Expected columns in the CSV:
- `group_name` - name of the Entra ID group
- `role_name` - name of the directory role
- `pim_enabled` - string "true" for eligible (PIM) assignment, "false" for active assignment
