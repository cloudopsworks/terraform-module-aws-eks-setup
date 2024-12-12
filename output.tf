##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

output "cluster_name" {
  value = local.cluster_name
}

output "cluster_endpoint" {
  value = module.this.cluster_endpoint
}

output "cluster_ca_certificate_base64" {
  value = module.this.cluster_certificate_authority_data
}

output "cluster_arn" {
  value = module.this.cluster_arn
}

output "cluster_subnet_ids" {
  value = var.vpc.subnet_ids
}

output "kms_key_name" {
  value = aws_kms_alias.cluster_kms.name
}

output "kms_key_arn" {
  value = aws_kms_key.cluster_kms.arn
}

output "kms_key_id" {
  value = aws_kms_key.cluster_kms.key_id
}


output "eks_worker_key" {
  value = tls_private_key.keypair_gen.public_key_openssh
}

output "cluster_sg_default" {
  value = {
    name = aws_security_group.cluster_default.name
    id   = aws_security_group.cluster_default.id
  }
}

output "cluster_sg_master" {
  value = {
    name = aws_security_group.master.name
    id   = aws_security_group.master.id
  }
}

output "cluster_sg_worker" {
  value = {
    name = aws_security_group.worker.name
    id   = aws_security_group.worker.id
  }
}

output "lb_irsa_role" {
  value = {
    arn  = module.lb_irsa_role.iam_role_arn
    name = module.lb_irsa_role.iam_role_name
  }
}

output "vpc_cni_irsa_role" {
  value = {
    arn  = module.vpc_cni_irsa_role.iam_role_arn
    name = module.vpc_cni_irsa_role.iam_role_name
  }
}

output "ebs_csi_irsa_role" {
  value = {
    arn  = module.ebs_csi_irsa_role.iam_role_arn
    name = module.ebs_csi_irsa_role.iam_role_name
  }
}

output "efs_csi_irsa_role" {
  value = {
    arn  = module.efs_csi_irsa_role.iam_role_arn
    name = module.efs_csi_irsa_role.iam_role_name
  }
}

output "ext_dns_irsa_role" {
  value = {
    arn  = module.ext_dns_irsa_role.iam_role_arn
    name = module.ext_dns_irsa_role.iam_role_name
  }
}

output "autoscaler_irsa_role" {
  value = {
    arn  = module.autoscaler_irsa_role.iam_role_arn
    name = module.autoscaler_irsa_role.iam_role_name
  }
}

output "cert_mgr_irsa_role" {
  value = {
    arn  = module.cert_mgr_irsa_role.iam_role_arn
    name = module.cert_mgr_irsa_role.iam_role_name
  }
}

output "s3_csi_irsa_role" {
  value = {
    arn  = module.s3_csi_irsa_role.iam_role_arn
    name = module.s3_csi_irsa_role.iam_role_name
  }
}

output "velero_irsa_role" {
  value = {
    arn  = module.velero_irsa_role.iam_role_arn
    name = module.velero_irsa_role.iam_role_name
  }
}