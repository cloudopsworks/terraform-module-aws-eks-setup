
resource "tls_private_key" "keypair_gen" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "local_file" "keypair_priv" {
  content  = tls_private_key.keypair_gen.private_key_pem
  filename = "pem-files/eks-${local.system_name}.pem"
}

resource "aws_key_pair" "eks_worker_key" {
  key_name   = "eks-${local.system_name}"
  public_key = tls_private_key.keypair_gen.public_key_openssh
}
