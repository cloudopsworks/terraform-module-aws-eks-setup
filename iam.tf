##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

locals {
  master_role_new    = "eks-${local.system_name}-role"
  master_role_compat = "eks-role-${local.system_name}"
  master_role_name   = try(var.role_name_compat, false) ? local.master_role_compat : local.master_role_new
}

data "aws_caller_identity" "current" {}

data "aws_iam_policy_document" "eks_sts_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["eks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "master" {
  name               = local.master_role_name
  assume_role_policy = data.aws_iam_policy_document.eks_sts_assume_role.json
  tags               = local.all_tags
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_instance_profile" "master" {
  name = local.master_role_name
  role = aws_iam_role.master.name
  tags = local.all_tags
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "att-master-ClusterPolicy" {
  role       = aws_iam_role.master.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "att-master-ServicePolicy" {
  role       = aws_iam_role.master.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}

data "aws_iam_policy_document" "worker_sts_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

resource "aws_iam_role" "worker" {
  name               = "eks-${local.system_name}-worker-role"
  assume_role_policy = data.aws_iam_policy_document.worker_sts_assume_role.json
  tags               = local.all_tags
  lifecycle {
    create_before_destroy = true
  }
}

data "aws_iam_policy_document" "worker_kms_access" {
  statement {
    effect = "Allow"
    actions = [
      "kms:Decrypt",
      "kms:ListKeys",
      "kms:ListAliases",
      "kms:DescribeKey",
      "kms:GenerateDataKey",
      "kms:GenerateDataKeyPair",
      "kms:Encrypt",
      "kms:ReEncrypt",
      "kms:ReEncryptFrom",
      "kms:ReEncryptTo",
      "kms:ListResourceTags"
    ]
    resources = [
      aws_kms_key.cluster_kms.arn
    ]
  }
}

resource "aws_iam_role_policy" "worker" {
  name   = "eks-${local.system_name}-kms-access"
  role   = aws_iam_role.worker.id
  policy = data.aws_iam_policy_document.worker_kms_access.json
}

data "aws_iam_policy_document" "worker_csi_access" {
  statement {
    effect = "Allow"
    actions = [
      "ec2:AttachVolume",
      "ec2:CreateSnapshot",
      "ec2:CreateSnapshots",
      "ec2:CreateTags",
      "ec2:CreateVolume",
      "ec2:DeleteSnapshot",
      "ec2:DeleteTags",
      "ec2:DeleteVolume",
      "ec2:DescribeInstances",
      "ec2:DescribeSnapshots",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "ec2:DetachVolume",
      "ec2:ModifyVolume",
      "ec2:ModifyVolumeAttribute",
      "ec2:ImportVolume",
      "ec2:DescribeAvailabilityZones",
      "ec2:DescribeVolumesModifications"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "worker_csi" {
  name   = "eks-${local.system_name}-csi-volume-mgmt"
  role   = aws_iam_role.worker.id
  policy = data.aws_iam_policy_document.worker_csi_access.json
}

data "aws_iam_policy_document" "worker_autoscaling_access" {
  statement {
    effect = "Allow"
    actions = [
      "autoscaling:DescribeAutoScalingGroups",
      "autoscaling:DescribeAutoScalingInstances",
      "autoscaling:DescribeLaunchConfigurations",
      "autoscaling:DescribeTags",
      "autoscaling:SetDesiredCapacity",
      "autoscaling:TerminateInstanceInAutoScalingGroup",
      "ec2:DescribeLaunchTemplateVersions",
      "ec2:DescribeLaunchTemplates",
      "ec2:GetLaunchTemplateData"
    ]
    resources = ["*"]
  }
}

resource "aws_iam_role_policy" "worker_autoscaling" {
  name   = "eks-${local.system_name}-autoscaling-access"
  role   = aws_iam_role.worker.id
  policy = data.aws_iam_policy_document.worker_autoscaling_access.json
}

data "aws_iam_policy_document" "worker_ecr_access" {
  statement {
    effect = "Allow"
    actions = [
      "ecr:UntagResource",
      "ecr:CompleteLayerUpload",
      "ecr:TagResource",
      "ecr:UploadLayerPart",
      "ecr:InitiateLayerUpload",
      "ecr:PutImage"
    ]
    resources = [
      "arn:aws:ecr:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:repository/*"
    ]
  }
}

resource "aws_iam_role_policy" "worker_ecrwrite" {
  name   = "eks-${local.system_name}-ecr-worker-write"
  role   = aws_iam_role.worker.id
  policy = data.aws_iam_policy_document.worker_ecr_access.json
}

data "aws_iam_policy_document" "worker_cloudwatch_access" {
  statement {
    effect = "Allow"
    actions = [
      "cloudwatch:PutMetricData",
      "ec2:DescribeTags",
      "ec2:DescribeVolumes",
      "logs:PutLogEvents",
      "logs:DescribeLogStreams",
      "logs:DescribeLogGroups",
      "logs:CreateLogStream",
      "logs:CreateLogGroup"
    ]
    resources = ["*"]
  }
  statement {
    effect = "Allow"
    actions = [
      "ssm:GetParameter",
      "ssm:PutParameter"
    ]
    resources = [
      "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
    ]
  }
}

resource "aws_iam_role_policy" "worker_cloudwatch_rw" {
  name   = "eks-${local.system_name}-cw-worker-write"
  role   = aws_iam_role.worker.id
  policy = data.aws_iam_policy_document.worker_cloudwatch_access.json
}

resource "aws_iam_instance_profile" "worker" {
  name = "eks-${local.system_name}-worker-role"
  role = aws_iam_role.worker.name
  tags = local.all_tags
  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role_policy_attachment" "worker_AmazonEKSWorkerNodePolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "worker_AmazonEKS_CNI_Policy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "worker_AmazonEC2ContainerRegistryReadOnly" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "worker_CloudWatchAgentServerPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/CloudWatchAgentServerPolicy"
  role       = aws_iam_role.worker.name
}

resource "aws_iam_role_policy_attachment" "worker_AWSXrayWriteOnlyAccess" {
  policy_arn = "arn:aws:iam::aws:policy/AWSXrayWriteOnlyAccess"
  role       = aws_iam_role.worker.name
}

# May not needed for EKS nodes
resource "aws_iam_role_policy_attachment" "worker_SSMManagedInstance" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.worker.name
}