##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

resource "aws_security_group" "cluster_default" {
  name        = "eks-def-sg-${local.system_name}"
  description = "Default Cluster Security Group"
  vpc_id      = var.vpc.vpc_id

  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.all_tags, tomap({
    "Name" = "eks-def-sg-${local.system_name}"
  }))
}

resource "aws_security_group" "master" {
  name        = "eks-master-sg-${local.system_name}"
  description = "Access Cluster Security Group"
  vpc_id      = var.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.all_tags, tomap({
    "Name" = "eks-master-sg-${local.system_name}"
  }))
}

resource "aws_security_group_rule" "eks_master_ingress_workstation_https" {
  count = length(try(var.vpc.vpn_accesses, []))

  cidr_blocks       = [var.vpc.vpn_accesses[count.index]]
  description       = "Allow workstation ${var.vpc.vpn_accesses[count.index]} to communicate with the cluster API Server"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.master.id
  type              = "ingress"
}

resource "aws_security_group_rule" "eks_master_ingress_workers_https" {
  description              = "Allow Worker Nodes to communicate with the cluster API Server"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.master.id
  source_security_group_id = aws_security_group.worker.id
  type                     = "ingress"
}

data "aws_security_group" "bastion_security_group" {
  id = var.vpc.ssh_admin_security_group_id
}

resource "aws_security_group_rule" "eks_master_ingress_bastion" {
  description              = "Allow Bastion to communicate with the cluster API Server"
  from_port                = 0
  to_port                  = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.master.id
  source_security_group_id = data.aws_security_group.bastion_security_group.id
  type                     = "ingress"
}



resource "aws_security_group" "worker" {
  name        = "eks-worker-sg-${local.system_name}"
  description = "Security group for all nodes in the cluster"
  vpc_id      = var.vpc.vpc_id

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = merge(local.all_tags, tomap({
    "Name"                                        = "eks-worker-sg-${local.system_name}"
    "kubernetes.io/cluster/${local.cluster_name}" = "owned"
  }))
}

resource "aws_security_group_rule" "worker_ingress_bastion" {
  description              = "Allow SSH from bastion hosts"
  from_port                = 22
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = data.aws_security_group.bastion_security_group.id
  to_port                  = 22
  type                     = "ingress"
}


resource "aws_security_group_rule" "worker_ingress_self" {
  description              = "Allow node to communicate with each other"
  from_port                = 0
  protocol                 = "-1"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.worker.id
  to_port                  = 65535
  type                     = "ingress"
}

resource "aws_security_group_rule" "worker_ingress_cluster" {
  description              = "Allow worker Kubelets and pods to receive communication from the cluster control plane"
  from_port                = 1025
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.master.id
  to_port                  = 65535
  type                     = "ingress"
}

### Worker Node Access from EKS Master
resource "aws_security_group_rule" "eks_cluster_ingress_node_https" {
  description              = "Allow cluster to communicate with the pods extensions API Server"
  from_port                = 443
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.master.id
  to_port                  = 443
  type                     = "ingress"
}

### Worker Node Access from EKS Master
resource "aws_security_group_rule" "eks_cluster_ingress_node_http" {
  description              = "Allow cluster to communicate with the pods extensions API Server (HTTP)"
  from_port                = 80
  protocol                 = "tcp"
  security_group_id        = aws_security_group.worker.id
  source_security_group_id = aws_security_group.master.id
  to_port                  = 80
  type                     = "ingress"
}
