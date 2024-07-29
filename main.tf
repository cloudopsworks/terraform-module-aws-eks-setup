locals {
  cluster_name = "eks-${local.system_name}"
  node_group_defaults = {
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
          encrypted  = true
          kms_key_id = aws_kms_key.cluster_kms.arn
        }
      }
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

    create_iam_role = false
    iam_role_arn    = aws_iam_role.worker.arn

    tags = {
      "k8s.io/cluster-autoscaler/enabled"               = "true"
      "k8s.io/cluster-autoscaler/${local.cluster_name}" = "owned"
    }
  }

  map_roles = var.map_roles
}


module "this" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.00"

  vpc_id              = var.vpc.vpc_id
  cluster_name        = local.cluster_name
  subnet_ids          = var.vpc.private_subnets
  cluster_version     = var.cluster_version
  authentication_mode = "API_AND_CONFIG_MAP"

  cluster_endpoint_private_access      = true
  cluster_endpoint_public_access       = true
  cluster_endpoint_public_access_cidrs = var.access_cidr

  cluster_addons = {
    coredns = {
      resolve_conflicts_on_create = "OVERWRITE"
      most_recent                 = true
    }
    kube-proxy = {
      most_recent = true
    }
    vpc-cni = {
      #resolve_conflicts_on_create = "OVERWRITE"
      most_recent = true
    }
    aws-ebs-csi-driver = {
      most_recent = true
    }
    aws-efs-csi-driver = {
      most_recent = true
    }
    snapshot-controller = {
      most_recent = true
    }
    amazon-cloudwatch-observability = {
      #resolve_conflicts_on_create = "OVERWRITE"
      most_recent = true
    }
    eks-pod-identity-agent = {
      #resolve_conflicts_on_create = "OVERWRITE"
      most_recent = true
    }
  }

  create_kms_key = false
  cluster_encryption_config = {
    provider_key_arn = aws_kms_key.cluster_kms.arn
    resources        = ["secrets"]
  }

  create_cluster_security_group = false
  cluster_security_group_id     = aws_security_group.master.id
  create_iam_role               = false
  iam_role_arn                  = aws_iam_role.master.arn
  enable_irsa                   = true

  cluster_enabled_log_types              = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  cloudwatch_log_group_retention_in_days = 30

  create_node_security_group = false
  node_security_group_id     = aws_security_group.worker.id

  #create_aws_auth_configmap = false
  #manage_aws_auth_configmap = true
  #aws_auth_roles            = local.map_roles
  #aws_auth_users            = var.map_users

  eks_managed_node_group_defaults  = local.node_group_defaults
  eks_managed_node_groups          = var.node_groups
  self_managed_node_group_defaults = local.self_node_group_defaults
  self_managed_node_groups         = var.self_node_groups

  tags = local.all_tags
  cluster_tags = merge(
    {
      Name = local.cluster_name
    },
    local.all_tags
  )
}
