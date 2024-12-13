##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  vpc_cni_irsa_role_name = "eks-${local.system_name}-vpc-cni-role"
  vpc_cni_irsa_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.vpc_cni_irsa_role_name}"
  ebs_cni_irsa_role_name = "eks-${local.system_name}-ebs-csi-role"
  ebs_cni_irsa_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.ebs_cni_irsa_role_name}"
  efs_cni_irsa_role_name = "eks-${local.system_name}-efs-csi-role"
  efs_cni_irsa_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.efs_cni_irsa_role_name}"

}

module "vpc_cni_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "~> 5.0"
  create_role           = try(var.irsa.vpc_cni.enabled, false)
  role_name             = local.vpc_cni_irsa_role_name
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.vpc_cni.namespace_service_accounts, [])
    }
  }
  role_policy_arns = try(var.irsa.vpc_cni.role_policy_arns, {})
  tags             = local.all_tags
}

module "lb_irsa_role" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                = "~> 5.0"
  create_role                            = try(var.irsa.lb.enabled, false)
  role_name                              = "eks-${local.system_name}-lb-role"
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.lb.namespace_service_accounts, [])
    }
  }
  role_policy_arns = try(var.irsa.lb.role_policy_arns, {})
  tags             = local.all_tags
}

module "ebs_csi_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "~> 5.0"
  create_role           = try(var.irsa.ebs_csi.enabled, false)
  role_name             = local.ebs_cni_irsa_role_name
  attach_ebs_csi_policy = true
  ebs_csi_kms_cmk_ids   = concat(try(var.irsa.ebs_csi.kms_cmk_ids, []), [aws_kms_key.cluster_kms.arn])
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.ebs_csi.namespace_service_accounts, [])
    }
  }
  role_policy_arns = try(var.irsa.ebs_csi.role_policy_arns, {})
  tags             = local.all_tags
}

module "efs_csi_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "~> 5.0"
  create_role           = try(var.irsa.efs_csi.enabled, false)
  role_name             = local.efs_cni_irsa_role_name
  attach_efs_csi_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.efs_csi.namespace_service_accounts, [])
    }
  }
  role_policy_arns = try(var.irsa.efs_csi.role_policy_arns, {})
  tags             = local.all_tags
}

module "ext_dns_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "~> 5.0"
  create_role                   = try(var.irsa.external_dns.enabled, false)
  role_name                     = "eks-${local.system_name}-ext-dns-role"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = try(var.irsa.external_dns.hosted_zone_arns, [])
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.external_dns.namespace_service_accounts, [])
    }
  }
  role_policy_arns = try(var.irsa.external_dns.role_policy_arns, {})
  tags             = local.all_tags
}

module "autoscaler_irsa_role" {
  source                           = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                          = "~> 5.0"
  create_role                      = try(var.irsa.cluster_autoscaler.enabled, false)
  role_name                        = "eks-${local.system_name}-autoscaler-role"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [local.cluster_name]
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.cluster_autoscaler.namespace_service_accounts, [])
    }
  }
  role_policy_arns = try(var.irsa.cluster_autoscaler.role_policy_arns, {})
  tags             = local.all_tags
}

module "cert_mgr_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "~> 5.0"
  create_role                   = try(var.irsa.cert_manager.enabled, false)
  role_name                     = "eks-${local.system_name}-cert-mgr-role"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = try(var.irsa.cert_manager.hosted_zone_arns, [])
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.cert_manager.namespace_service_accounts, [])
    }
  }
  role_policy_arns = try(var.irsa.cert_manager.role_policy_arns, {})
  tags             = local.all_tags
}

module "s3_csi_irsa_role" {
  source                          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                         = "~> 5.0"
  create_role                     = try(var.irsa.s3_csi.enabled, false)
  role_name                       = "eks-${local.system_name}-s3-csi-role"
  attach_mountpoint_s3_csi_policy = true
  mountpoint_s3_csi_bucket_arns   = try(var.irsa.s3_csi.bucket_arns, [])
  mountpoint_s3_csi_kms_arns      = try(var.irsa.s3_csi.kms_arns, [])
  mountpoint_s3_csi_path_arns     = try(var.irsa.s3_csi.path_arns, [])
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.s3_csi.namespace_service_accounts, [])
    }
  }
  role_policy_arns = try(var.irsa.s3_csi.role_policy_arns, {})
  tags             = local.all_tags
}

module "velero_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "~> 5.0"
  create_role           = try(var.irsa.velero.enabled, false)
  role_name             = "eks-${local.system_name}-velero-role"
  attach_velero_policy  = true
  velero_s3_bucket_arns = try(var.irsa.velero.bucket_arns, [])
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.velero.namespace_service_accounts, [])
    }
  }
  role_policy_arns = try(var.irsa.velero.role_policy_arns, {})
  tags             = local.all_tags
}

module "prometheus_irsa_role" {
  source                                          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                         = "~> 5.0"
  create_role                                     = try(var.irsa.prometheus.enabled, false)
  role_name                                       = "eks-${local.system_name}-prometheus-role"
  attach_amazon_managed_service_prometheus_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.prometheus.namespace_service_accounts, [])
    }
  }
  role_policy_arns = try(var.irsa.prometheus.role_policy_arns, {})
  tags             = local.all_tags
}