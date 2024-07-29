output "cluster_name" {
  value = var.cluster_name
}

output "cluster_endpoint" {
  value = module.this.cluster_endpoint
}

output "cluster_ca_certificate_base64" {
  value = module.this.cluster_certificate_authority_data
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

# output "backup_bucket" {
#   value = var.cluster_backup_bucket
# }