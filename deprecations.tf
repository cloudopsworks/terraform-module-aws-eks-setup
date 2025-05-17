##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  # This is a workaround for the issue with the aws_securityhub_account data source
  # not being able to be used in the output block.
  # The try function will return null if the data source is not available.
  access_entries = coalescelist(var.map_users, var.access_entries)
}