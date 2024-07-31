##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

data "aws_caller_identity" "current" {}

resource "aws_iam_role" "master" {
  name               = "eks-role-${local.system_name}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "eks.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY
  tags               = local.all_tags
}

resource "aws_iam_instance_profile" "master" {
  name = "eks-role-${local.system_name}"
  role = aws_iam_role.master.name
}

resource "aws_iam_role_policy_attachment" "att-master-ClusterPolicy" {
  role       = aws_iam_role.master.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
}

resource "aws_iam_role_policy_attachment" "att-master-ServicePolicy" {
  role       = aws_iam_role.master.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSServicePolicy"
}


resource "aws_iam_role" "worker" {
  name               = "eks-worker-role-${local.system_name}"
  assume_role_policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "worker" {
  name = "eks-kms-access-${local.system_name}"
  role = aws_iam_role.worker.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "kms:*"
      ],
      "Effect": "Allow",
      "Resource": "${aws_kms_key.cluster_kms.arn}"
    }
  ]
}
POLICY

}

resource "aws_iam_role_policy" "worker_csi" {
  name = "eks-csi-volume-mgmt-${local.system_name}"
  role = aws_iam_role.worker.id

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Action": [
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
      ],
      "Resource": "*"
    }
  ]
}
POLICY
}

resource "aws_iam_role_policy" "worker_autoscaling" {
  name = "eks-autoscaling-access-${local.system_name}"
  role = aws_iam_role.worker.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "autoscaling:DescribeAutoScalingGroups",
                "autoscaling:DescribeAutoScalingInstances",
                "autoscaling:DescribeLaunchConfigurations",
                "autoscaling:DescribeTags",
                "autoscaling:SetDesiredCapacity",
                "autoscaling:TerminateInstanceInAutoScalingGroup",
                "ec2:DescribeLaunchTemplateVersions",
                "ec2:DescribeLaunchTemplates",
                "ec2:GetLaunchTemplateData"
            ],
            "Resource": "*"
        }
    ]
}
POLICY

}

resource "aws_iam_role_policy" "worker_ecrwrite" {
  name = "eks-ecr-worker-write-${local.system_name}"
  role = aws_iam_role.worker.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "VisualEditor0",
            "Effect": "Allow",
            "Action": [
                "ecr:UntagResource",
                "ecr:CompleteLayerUpload",
                "ecr:TagResource",
                "ecr:UploadLayerPart",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage"
            ],
            "Resource": "*"
        }
    ]
}
POLICY

}

# resource "aws_iam_role_policy" "worker_s3-backup" {
#   name = "s3-worker-write-${local.system_name}"
#   role = aws_iam_role.worker.id
#
#   policy = <<POLICY
# {
#   "Statement": [
#     {
#       "Action": [
#         "s3:ListBucket",
#         "s3:GetBucketLocation",
#         "s3:ListBucketMultipartUploads",
#         "s3:ListBucketVersions"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "arn:aws:s3:::${var.cluster_backup_bucket}"
#       ]
#     },
#     {
#       "Action": [
#         "s3:GetObject",
#         "s3:PutObject",
#         "s3:DeleteObject",
#         "s3:AbortMultipartUpload",
#         "s3:ListMultipartUploadParts"
#       ],
#       "Effect": "Allow",
#       "Resource": [
#         "arn:aws:s3:::${var.cluster_backup_bucket}/*"
#       ]
#     }
#   ],
#   "Version": "2012-10-17"
# }
# POLICY
#
# }

# resource "aws_iam_role_policy" "worker_route53" {
#   name = "Route53Writer-${local.system_name}"
#   role = aws_iam_role.worker.id
#
#   policy = <<POLICY
# {
#  "Version": "2012-10-17",
#  "Statement": [
#    {
#      "Effect": "Allow",
#      "Action": "route53:GetChange",
#      "Resource": "arn:aws:route53:::change/*"
#    },
#    {
#      "Effect": "Allow",
#      "Action": [
#        "route53:ChangeResourceRecordSets",
#        "route53:ListResourceRecordSets"
#      ],
#      "Resource": [
#        "arn:aws:route53:::hostedzone/*"
#      ]
#    },
#    {
#      "Effect": "Allow",
#      "Action": [
#        "route53:ListHostedZones",
#        "route53:ListHostedZonesByName"
#      ],
#      "Resource": [
#        "*"
#      ]
#    }
#  ]
# }
# POLICY
#
# }

resource "aws_iam_role_policy" "worker_cloudwatch_rw" {
  name = "eks-cw-worker-write-${local.system_name}"
  role = aws_iam_role.worker.id

  policy = <<POLICY
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Action": [
                "cloudwatch:PutMetricData",
                "ec2:DescribeTags",
                "ec2:DescribeVolumes",
                "logs:PutLogEvents",
                "logs:DescribeLogStreams",
                "logs:DescribeLogGroups",
                "logs:CreateLogStream",
                "logs:CreateLogGroup"
            ],
            "Resource": "*"
        },
        {
            "Effect": "Allow",
            "Action": [
                "ssm:GetParameter",
                "ssm:PutParameter"
            ],
            "Resource": "arn:aws:ssm:*:*:parameter/AmazonCloudWatch-*"
        }
    ]
}
POLICY
}

resource "aws_iam_instance_profile" "worker" {
  name = "eks-worker-role-${local.system_name}"
  role = aws_iam_role.worker.name
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
# resource "aws_iam_role_policy_attachment" "worker_SSMManagedInstance" {
#   policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
#   role       = aws_iam_role.worker.name
# }