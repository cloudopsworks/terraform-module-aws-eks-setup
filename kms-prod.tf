data "aws_iam_role" "service_role_for_autoscaling" {
  name = "AWSServiceRoleForAutoScaling"
}
data "aws_iam_role" "service_role_for_spot" {
  name = "AWSServiceRoleForEC2Spot"
}

data "aws_iam_policy_document" "kms_policy" {
  policy_id = "key-consolepolicy-3"
  version   = "2012-10-17"

  statement {
    sid    = "Enable IAM User Permissions"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        "arn:aws:iam::${data.aws_caller_identity.current}:root"
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow access for Key Administrators"
    effect = "Allow"
    principals {
      type        = "AWS"
      identifiers = var.policy_iam_users
    }
    actions = [
      "kms:Create*",
      "kms:Describe*",
      "kms:Enable*",
      "kms:List*",
      "kms:Put*",
      "kms:Update*",
      "kms:Revoke*",
      "kms:Disable*",
      "kms:Get*",
      "kms:Delete*",
      "kms:TagResource",
      "kms:UntagResource",
      "kms:ScheduleKeyDeletion",
      "kms:CancelKeyDeletion"
    ]
    resources = ["*"]
  }

  statement {
    sid    = "Allow ALL for CMK"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.worker.arn,
        aws_iam_role.master.arn
      ]
    }
    actions   = ["kms:*"]
    resources = ["*"]
  }

  statement {
    sid    = "Allow use of the CMK"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.master.arn,
        aws_iam_role.worker.arn,
        data.aws_iam_role.service_role_for_autoscaling.arn,
        data.aws_iam_role.service_role_for_spot.arn
      ]
    }
    actions = [
      "kms:CreateGrant",
      "kms:ListGrants",
      "kms:RevokeGrant"
    ]
    resources = ["*"]
    condition {
      test     = "Bool"
      variable = "kms:GrantIsForAWSResource"
      values   = ["true"]
    }
  }

  statement {
    sid    = "Allow attachment of persistent resources"
    effect = "Allow"
    principals {
      type = "AWS"
      identifiers = [
        aws_iam_role.master.arn,
        aws_iam_role.worker.arn,
        data.aws_iam_role.service_role_for_autoscaling.arn,
        data.aws_iam_role.service_role_for_spot.arn
      ]
    }
    actions = [
      "kms:Encrypt",
      "kms:Decrypt",
      "kms:ReEncrypt*",
      "kms:GenerateDataKey*",
      "kms:DescribeKey"
    ]
    resources = ["*"]
  }
}

resource "aws_kms_key" "cluster_kms" {
  description             = "EKS eks-${local.system_name} Cluster Encryption Key"
  deletion_window_in_days = 10
  enable_key_rotation     = true
  policy                  = data.aws_iam_policy_document.kms_policy.json

  tags = local.all_tags
}


resource "aws_kms_alias" "cluster_kms" {
  target_key_id = aws_kms_key.cluster_kms.key_id
  name          = "alias/encrypt/eks-${local.system_name}"
}
