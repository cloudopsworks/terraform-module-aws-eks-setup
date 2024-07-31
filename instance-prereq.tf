##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

resource "tls_private_key" "keypair_gen" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "keypair_priv" {
  content  = tls_private_key.keypair_gen.private_key_pem
  filename = "pem-files/${local.cluster_name}.pem"
}

resource "aws_key_pair" "eks_worker_key" {
  key_name   = local.cluster_name
  public_key = tls_private_key.keypair_gen.public_key_openssh
}
