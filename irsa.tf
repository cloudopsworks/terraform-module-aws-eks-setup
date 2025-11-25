##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  policy_prefix                = "eks-${local.system_name_short}-"
  vpc_cni_irsa_role_name       = "eks-${local.system_name}-vpc-cni-role"
  vpc_cni_irsa_role_arn        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.vpc_cni_irsa_role_name}"
  ebs_cni_irsa_role_name       = "eks-${local.system_name}-ebs-csi-role"
  ebs_cni_irsa_role_arn        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.ebs_cni_irsa_role_name}"
  efs_cni_irsa_role_name       = "eks-${local.system_name}-efs-csi-role"
  efs_cni_irsa_role_arn        = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.efs_cni_irsa_role_name}"
  cloudwatch_irsa_role_name    = "eks-${local.system_name}-cw-observability-role"
  cloudwatch_irsa_role_arn     = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.cloudwatch_irsa_role_name}"
  secrets_store_irsa_role_name = "eks-${local.system_name}-secrets-store-role"
  secrets_store_irsa_role_arn  = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.secrets_store_irsa_role_name}"
  adot_irsa_role_name          = "eks-${local.system_name}-adot-role"
  adot_irsa_role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.adot_irsa_role_name}"
  keda_irsa_role_name          = "eks-${local.system_name}-keda-role"
  keda_irsa_role_arn           = "arn:aws:iam::${data.aws_caller_identity.current.account_id}:role/${local.keda_irsa_role_name}"
}

module "vpc_cni_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version               = "~> 6.2"
  create                = try(var.irsa.vpc_cni.enabled, false)
  name                  = local.vpc_cni_irsa_role_name
  policy_name           = "${local.vpc_cni_irsa_role_name}-pol"
  use_name_prefix       = false
  attach_vpc_cni_policy = true
  vpc_cni_enable_ipv4   = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.vpc_cni.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.vpc_cni.role_policy_arns, {})
  tags     = local.all_tags
}

module "lb_irsa_role" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                                = "~> 6.2"
  create                                 = try(var.irsa.lb.enabled, false)
  name                                   = "eks-${local.system_name}-lb-role"
  policy_name                            = "eks-${local.system_name}-lb-role-pol"
  use_name_prefix                        = false
  attach_load_balancer_controller_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.lb.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.lb.role_policy_arns, {})
  tags     = local.all_tags
}

module "ebs_csi_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version               = "~> 6.2"
  create                = try(var.irsa.ebs_csi.enabled, false)
  name                  = local.ebs_cni_irsa_role_name
  policy_name           = "${local.ebs_cni_irsa_role_name}-pol"
  use_name_prefix       = false
  attach_ebs_csi_policy = true
  ebs_csi_kms_cmk_arns  = concat(try(var.irsa.ebs_csi.kms_cmk_ids, []), [aws_kms_key.cluster_kms.arn])
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.ebs_csi.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.ebs_csi.role_policy_arns, {})
  tags     = local.all_tags
}

module "efs_csi_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version               = "~> 6.2"
  create                = try(var.irsa.efs_csi.enabled, false)
  name                  = local.efs_cni_irsa_role_name
  policy_name           = "${local.efs_cni_irsa_role_name}-pol"
  use_name_prefix       = false
  attach_efs_csi_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.efs_csi.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.efs_csi.role_policy_arns, {})
  tags     = local.all_tags
}

module "ext_dns_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                       = "~> 6.2"
  create                        = try(var.irsa.external_dns.enabled, false)
  name                          = "eks-${local.system_name}-ext-dns-role"
  policy_name                   = "eks-${local.system_name}-ext-dns-role-pol"
  use_name_prefix               = false
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = try(var.irsa.external_dns.hosted_zone_arns, [])
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.external_dns.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.external_dns.role_policy_arns, {})
  tags     = local.all_tags
}

module "autoscaler_irsa_role" {
  source                           = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                          = "~> 6.2"
  create                           = try(var.irsa.cluster_autoscaler.enabled, false)
  name                             = "eks-${local.system_name}-autoscaler-role"
  policy_name                      = "eks-${local.system_name}-autoscaler-role-pol"
  use_name_prefix                  = false
  attach_cluster_autoscaler_policy = true
  cluster_autoscaler_cluster_names = [local.cluster_name]
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.cluster_autoscaler.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.cluster_autoscaler.role_policy_arns, {})
  tags     = local.all_tags
}

module "cert_mgr_irsa_role" {
  source                        = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                       = "~> 6.2"
  create                        = try(var.irsa.cert_manager.enabled, false)
  name                          = "eks-${local.system_name}-cert-mgr-role"
  policy_name                   = "eks-${local.system_name}-cert-mgr-role-pol"
  use_name_prefix               = false
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = try(var.irsa.cert_manager.hosted_zone_arns, [])
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.cert_manager.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.cert_manager.role_policy_arns, {})
  tags     = local.all_tags
}

module "s3_csi_irsa_role" {
  source                          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                         = "~> 6.2"
  create                          = try(var.irsa.s3_csi.enabled, false)
  name                            = "eks-${local.system_name}-s3-csi-role"
  policy_name                     = "eks-${local.system_name}-s3-csi-role-pol"
  use_name_prefix                 = false
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
  policies = try(var.irsa.s3_csi.role_policy_arns, {})
  tags     = local.all_tags
}

module "velero_irsa_role" {
  source                = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version               = "~> 6.2"
  create                = try(var.irsa.velero.enabled, false)
  name                  = "eks-${local.system_name}-velero-role"
  policy_name           = "eks-${local.system_name}-velero-role-pol"
  use_name_prefix       = false
  attach_velero_policy  = true
  velero_s3_bucket_arns = try(var.irsa.velero.bucket_arns, [])
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.velero.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.velero.role_policy_arns, {})
  tags     = local.all_tags
}

module "prometheus_irsa_role" {
  source                                          = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                                         = "~> 6.2"
  create                                          = try(var.irsa.prometheus.enabled, false)
  name                                            = "eks-${local.system_name}-prometheus-role"
  policy_name                                     = "eks-${local.system_name}-prometheus-role-pol"
  use_name_prefix                                 = false
  attach_amazon_managed_service_prometheus_policy = true
  amazon_managed_service_prometheus_workspace_arns = try(var.irsa.prometheus.workspace_arns, [])
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.prometheus.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.prometheus.role_policy_arns, {})
  tags     = local.all_tags
}

module "cloudwatch_irsa_role" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                                = "~> 6.2"
  create                                 = try(var.irsa.cloudwatch.enabled, false)
  name                                   = local.cloudwatch_irsa_role_name
  policy_name                            = "${local.cloudwatch_irsa_role_name}-pol"
  use_name_prefix                        = false
  attach_cloudwatch_observability_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.cloudwatch.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.cloudwatch.role_policy_arns, {})
  tags     = local.all_tags
}

module "secrets_store_irsa_role" {
  source                                             = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                                            = "~> 6.2"
  create                                             = try(var.irsa.secrets_store.enabled, false)
  name                                               = local.secrets_store_irsa_role_name
  policy_name                                        = "${local.secrets_store_irsa_role_name}-pol"
  use_name_prefix                                    = false
  attach_external_secrets_policy                     = true
  external_secrets_secrets_manager_create_permission = try(var.irsa.secrets_store.secrets_manager_create_permission, false)
  external_secrets_secrets_manager_arns              = try(var.irsa.secrets_store.secrets_manager_arns, [])
  external_secrets_ssm_parameter_arns                = try(var.irsa.secrets_store.ssm_parameter_arns, [])
  external_secrets_kms_key_arns                      = try(var.irsa.secrets_store.kms_key_arns, [])
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.secrets_store.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.secrets_store.role_policy_arns, {})
  tags     = local.all_tags
}

module "adot_irsa_role" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                                = "~> 6.2"
  create                                 = try(var.irsa.adot.enabled, false)
  name                                   = local.adot_irsa_role_name
  policy_name                            = "${local.adot_irsa_role_name}-pol"
  use_name_prefix                        = false
  attach_external_secrets_policy         = true
  attach_cloudwatch_observability_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.adot.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.adot.role_policy_arns, {})
  tags     = local.all_tags
}

module "keda_irsa_role" {
  source                                 = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts"
  version                                = "~> 6.2"
  create                                 = try(var.irsa.keda.enabled, false)
  name                                   = local.keda_irsa_role_name
  policy_name                            = "${local.keda_irsa_role_name}-pol"
  use_name_prefix                        = false
  attach_external_secrets_policy         = true
  attach_cloudwatch_observability_policy = true
  oidc_providers = {
    main = {
      provider_arn               = module.this.oidc_provider_arn
      namespace_service_accounts = try(var.irsa.keda.namespace_service_accounts, [])
    }
  }
  policies = try(var.irsa.keda.role_policy_arns, {})
  tags     = local.all_tags
}