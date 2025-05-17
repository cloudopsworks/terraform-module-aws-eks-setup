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

# resource "aws_eks_access_entry" "cluster_access_entry" {
#   for_each = { for item in var.map_users : item.username => item }
#
#   cluster_name      = module.this.cluster_name
#   principal_arn     = each.value.userarn
#   user_name         = try(each.value.username, each.value.userarn)
#   type              = "STANDARD"
#   kubernetes_groups = try(each.value.groups, null)
#
#   tags = local.all_tags
# }
#
# resource "aws_eks_access_policy_association" "cluster_access_entry" {
#   for_each = { for item in var.map_users : item.username => item }
#
#   cluster_name  = module.this.cluster_name
#   principal_arn = each.value.userarn
#   policy_arn    = try(each.value.policy_arn, "arn:aws:eks::aws:cluster-access-policy/AmazonEKSViewPolicy")
#
#   access_scope {
#     type       = length(try(each.value.namespaces, [])) > 0 ? "namespace" : "cluster"
#     namespaces = try(each.value.namespaces, null)
#   }
# }