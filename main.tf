##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

locals {
  cluster_name = "eks-${local.system_name}"
  node_group_defaults = {
    use_name_prefix = true
    disk_size       = 30
    instance_types  = ["m6i.xlarge", "m5.xlarge", "m5a.xlarge", "m6a.xlarge"]
    subnet_ids      = var.vpc.private_subnets
    cluster_version = var.cluster_version

    iam_instance_profile_name = aws_iam_instance_profile.worker.name
    key_name                  = aws_key_pair.eks_worker_key.key_name
    #root_kms_key_id           = aws_kms_key.this-prod-kms.arn
    #root_encrypted            = "true"

    # Remote access cannot be specified with a launch template
    # remote_access = {
    #   ec2_ssh_key               = aws_key_pair.eks_worker_key.key_name
    #   source_security_group_ids = [var.vpc.ssh_admin_security_group_id]
    # }

    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          encrypted   = true
          volume_size = var.node_volume_size
          volume_type = var.node_volume_type
          kms_key_id  = aws_kms_key.cluster_kms.arn
        }
      }
    }

    metadata_options = {
      http_put_response_hop_limit = 2
      http_tokens                 = "required"
      http_endpoint               = "enabled"
    }

    create_iam_role = false
    iam_role_arn    = aws_iam_role.worker.arn

    tags = {
      "k8s.io/cluster-autoscaler/enabled"               = "true"
      "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
    }
  }

  self_node_group_defaults = {
    instance_type                          = "m6i.xlarge"
    update_launch_template_default_version = true
    cluster_version                        = var.cluster_version
    iam_role_additional_policies = [
      "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
    ]

    disk_size      = 30
    instance_types = ["m6i.xlarge", "m5.xlarge", "m5a.xlarge", "m6a.xlarge"]
    subnet_ids     = var.vpc.private_subnets

    iam_instance_profile_name = aws_iam_instance_profile.worker.name
    key_name                  = aws_key_pair.eks_worker_key.key_name
    # root_kms_key_id           = aws_kms_key.this-prod-kms.arn
    # root_encrypted            = "true"

    # Remote access cannot be specified with a launch template
    # remote_access = {
    #   ec2_ssh_key               = aws_key_pair.eks_worker_key.key_name
    #   source_security_group_ids = [var.vpc.ssh_admin_security_group_id]
    # }

    block_device_mappings = {
      xvda = {
        device_name = "/dev/xvda"
        ebs = {
          encrypted             = true
          kms_key_id            = aws_kms_key.cluster_kms.arn
          delete_on_termination = true
        }
      }
    }

    metadata_options = {
      http_put_response_hop_limit = 2
      http_tokens                 = "required"
      http_endpoint               = "enabled"
    }

    create_iam_role = false
    iam_role_arn    = aws_iam_role.worker.arn

    tags = {
      "k8s.io/cluster-autoscaler/enabled"               = "true"
      "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
    }
  }
}

module "this" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 21.0"

  vpc_id              = var.vpc.vpc_id
  name                = local.cluster_name
  subnet_ids          = var.vpc.private_subnets
  kubernetes_version  = var.cluster_version
  authentication_mode = "API_AND_CONFIG_MAP"

  enable_cluster_creator_admin_permissions = var.creator_admin_permissions
  # create_auto_mode_iam_resources = true
  # compute_config = {
  #   enabled = true
  # }

  endpoint_private_access      = var.private_api_server
  endpoint_public_access       = var.public_api_server
  endpoint_public_access_cidrs = var.access_cidrs

  addons = local.cluster_addons

  create_kms_key = false
  encryption_config = {
    provider_key_arn = aws_kms_key.cluster_kms.arn
    resources        = ["secrets"]
  }

  create_security_group = false
  security_group_id     = aws_security_group.master.id
  create_iam_role       = false
  iam_role_arn          = aws_iam_role.master.arn
  enable_irsa           = true

  enabled_log_types                      = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days = var.log_group_retention

  create_node_security_group = false
  node_security_group_id     = aws_security_group.worker.id

  #create_aws_auth_configmap = false
  #manage_aws_auth_configmap = true
  #aws_auth_roles            = local.map_roles
  #aws_auth_users            = var.map_users
  access_entries = local.access_entries

  eks_managed_node_groups  = { for k, ng in var.node_groups : k => merge(local.node_group_defaults, ng) }
  self_managed_node_groups = { for k, ng in var.self_node_groups : k => merge(local.self_node_group_defaults, ng) }

  tags = local.all_tags
  cluster_tags = merge(
    {
      Name = local.cluster_name
    },
    local.all_tags
  )
}
