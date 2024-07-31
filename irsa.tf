##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

module "vpc_cni_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "~> 5.0"
  create_role           = try(var.irsa.vpc_cni.enabled, false)
  role_name             = "eks-vpc-cni-role-${local.system_name_short}"
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = var.irsa.namespace_service_accounts
    }
  }
  tags = local.all_tags
}

module "lb_irsa_role" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                                = "~> 5.0"
  create_role                            = try(var.irsa.lb.enabled, false)
  role_name                              = "eks-lb-role-${local.system_name_short}"
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = var.irsa.namespace_service_accounts
    }
  }
  tags = local.all_tags
}

module "ebs_csi_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "~> 5.0"
  create_role           = try(var.irsa.ebs_csi.enabled, false)
  role_name             = "eks-ebs-csi-role-${local.system_name_short}"
  attach_ebs_csi_policy = true
  ebs_csi_kms_cmk_ids   = var.irsa.ebs_csi.kms_cmk_ids
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = var.irsa.namespace_service_accounts
    }
  }
  tags = local.all_tags
}

module "efs_csi_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "~> 5.0"
  create_role           = try(var.irsa.efs_csi.enabled, false)
  role_name             = "eks-efs-csi-role-${local.system_name_short}"
  attach_efs_csi_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = var.irsa.namespace_service_accounts
    }
  }
  tags = local.all_tags
}

module "ext_dns_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "~> 5.0"
  create_role                   = try(var.irsa.external_dns.enabled, false)
  role_name                     = "eks-ext-dns-role-${local.system_name_short}"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = var.irsa.external_dns.hosted_zone_arns
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = var.irsa.namespace_service_accounts
    }
  }
  tags = local.all_tags
}

module "autoscaler_irsa_role" {
  source                           = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                          = "~> 5.0"
  create_role                      = try(var.irsa.cluster_autoscaler.enabled, false)
  role_name                        = "eks-autoscaler-role-${local.system_name_short}"
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [local.cluster_name]
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = var.irsa.namespace_service_accounts
    }
  }
  tags = local.all_tags
}

module "cert_mgr_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                       = "~> 5.0"
  create_role                   = try(var.irsa.cert_manager.enabled, false)
  role_name                     = "eks-cert-mgr-role-${local.system_name_short}"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = var.irsa.cert_manager.hosted_zone_arns
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = var.irsa.namespace_service_accounts
    }
  }
  tags = local.all_tags
}

module "s3_csi_irsa_role" {
  source                          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version                         = "~> 5.0"
  create_role                     = try(var.irsa.s3_csi.enabled, false)
  role_name                       = "eks-s3-csi-role-${local.system_name_short}"
  attach_mountpoint_s3_csi_policy = true
  mountpoint_s3_csi_bucket_arns   = var.irsa.s3_csi.bucket_arns
  mountpoint_s3_csi_kms_arns      = var.irsa.s3_csi.kms_arns
  mountpoint_s3_csi_path_arns     = try(var.irsa.s3_csi.path_arns, [])
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = var.irsa.namespace_service_accounts
    }
  }
  tags = local.all_tags
}

module "velero_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version               = "~> 5.0"
  create_role           = try(var.irsa.velero.enabled, false)
  role_name             = "eks-velero-role-${local.system_name_short}"
  attach_velero_policy  = true
  velero_s3_bucket_arns = var.irsa.velero.bucket_arns
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = var.irsa.namespace_service_accounts
    }
  }
  tags = local.all_tags
}