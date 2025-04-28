##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  basic_addons = {
    coredns = {
      resolve_conflicts_on_create = "OVERWRITE"
      most_recent                 = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      #resolve_conflicts_on_create = "OVERWRITE"
      most_recent              = true
      service_account_role_arn = try(var.irsa.vpc_cni.enabled, false) ? local.vpc_cni_irsa_role_arn : null
    }
    aws-ebs-csi-driver = {
      most_recent              = true
      service_account_role_arn = try(var.irsa.ebs_csi.enabled, false) ? local.ebs_cni_irsa_role_arn : null
    }
  }
  efs_addon = try(var.addons.efs.enabled, false) ? {
    aws-efs-csi-driver = {
      most_recent              = true
      service_account_role_arn = try(var.irsa.efs_csi.enabled, false) ? local.efs_cni_irsa_role_arn : null
    }
  } : {}
  snapshot_addon = try(var.addons.snapshot.enabled, false) ? {
    snapshot-controller = {
      most_recent              = true
      service_account_role_arn = try(var.irsa.ebs_csi.enabled, false) ? local.ebs_cni_irsa_role_arn : null
    }
  } : {}
  cloudwatch_addon = try(var.addons.cloudwatch.enabled, false) ? {
    amazon-cloudwatch-observability = {
      #resolve_conflicts_on_create = "OVERWRITE"
      most_recent              = true
      service_account_role_arn = try(var.irsa.cloudwatch.enabled, false) ? local.cloudwatch_irsa_role_arn : null
    }
  } : {}
  pod_identity_addon = try(var.addons.pod_identity.enabled, false) ? {
    eks-pod-identity-agent = {
      #resolve_conflicts_on_create = "OVERWRITE"
      most_recent = true
    }
  } : {}
  adot_addon = try(var.addons.adot.enabled, false) ? {
    adot = {
      #resolve_conflicts_on_create = "OVERWRITE"
      most_recent              = true
      service_account_role_arn = try(var.irsa.adot.enabled, false) ? local.adot_irsa_role_arn : null
    }
  } : {}
  cluster_addons = merge(local.basic_addons, local.efs_addon, local.snapshot_addon, local.cloudwatch_addon,
  local.pod_identity_addon, local.adot_addon)
}