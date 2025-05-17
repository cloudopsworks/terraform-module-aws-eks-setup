##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

moved {
  from = aws_eks_access_entry.cluster_access_entry
  to   = module.this.aws_eks_access_entry.this
}

moved {
  from = aws_eks_access_policy_association.cluster_access_entry
  to   = module.this.aws_eks_access_policy_association.this
}