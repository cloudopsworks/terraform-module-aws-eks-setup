##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  # This is a workaround for the issue with the aws_securityhub_account data source
  # not being able to be used in the output block.
  # The try function will return null if the data source is not available.
  map_users = {
    for user in var.map_users : user.username => {
      principal_arn = user.userarn
      type          = try(user.type, "STANDARD")
      policy_associations = {
        default = {
          policy_arn = user.policy_arn
          access_scope = {
            type       = length(try(user.namespaces, [])) > 0 ? "namespace" : "cluster"
            namespaces = try(user.namespaces, null)
          }
        }
      }
    }
  }
  access_entries = merge(local.map_users, var.access_entries)
}