##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

moved {
  from = aws_eks_access_entry.cluster_access_entry
  to   = module.this.aws_eks_access_entry.this
}

moved {
  from = aws_eks_access_policy_association.cluster_access_entry
  to   = module.this.aws_eks_access_policy_association.this
}