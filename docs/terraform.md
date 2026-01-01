## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.3 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 6.20 |
| <a name="requirement_cloudinit"></a> [cloudinit](#requirement\_cloudinit) | ~> 2.3 |
| <a name="requirement_local"></a> [local](#requirement\_local) | ~> 2.2 |
| <a name="requirement_null"></a> [null](#requirement\_null) | ~> 3.2 |
| <a name="requirement_time"></a> [time](#requirement\_time) | ~> 0.10 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 6.20 |
| <a name="provider_local"></a> [local](#provider\_local) | ~> 2.2 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_adot_irsa_role"></a> [adot\_irsa\_role](#module\_adot\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_autoscaler_irsa_role"></a> [autoscaler\_irsa\_role](#module\_autoscaler\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_cert_mgr_irsa_role"></a> [cert\_mgr\_irsa\_role](#module\_cert\_mgr\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_cloudwatch_irsa_role"></a> [cloudwatch\_irsa\_role](#module\_cloudwatch\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_ebs_csi_irsa_role"></a> [ebs\_csi\_irsa\_role](#module\_ebs\_csi\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_efs_csi_irsa_role"></a> [efs\_csi\_irsa\_role](#module\_efs\_csi\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_ext_dns_irsa_role"></a> [ext\_dns\_irsa\_role](#module\_ext\_dns\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_keda_irsa_role"></a> [keda\_irsa\_role](#module\_keda\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_lb_irsa_role"></a> [lb\_irsa\_role](#module\_lb\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_prometheus_irsa_role"></a> [prometheus\_irsa\_role](#module\_prometheus\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_s3_csi_irsa_role"></a> [s3\_csi\_irsa\_role](#module\_s3\_csi\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_secrets_store_irsa_role"></a> [secrets\_store\_irsa\_role](#module\_secrets\_store\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_tags"></a> [tags](#module\_tags) | cloudopsworks/tags/local | 1.0.9 |
| <a name="module_this"></a> [this](#module\_this) | terraform-aws-modules/eks/aws | ~> 21.0 |
| <a name="module_velero_irsa_role"></a> [velero\_irsa\_role](#module\_velero\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |
| <a name="module_vpc_cni_irsa_role"></a> [vpc\_cni\_irsa\_role](#module\_vpc\_cni\_irsa\_role) | terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts | ~> 6.2 |

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_instance_profile.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.worker_autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.worker_cloudwatch_rw](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.worker_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy.worker_ecrwrite](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy) | resource |
| [aws_iam_role_policy_attachment.att-master-ClusterPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.att-master-ServicePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker_AWSXrayWriteOnlyAccess](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker_AmazonEC2ContainerRegistryReadOnly](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker_AmazonEKSWorkerNodePolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker_AmazonEKS_CNI_Policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker_CloudWatchAgentServerPolicy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.worker_SSMManagedInstance](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_key_pair.eks_worker_key](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/key_pair) | resource |
| [aws_kms_alias.cluster_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.cluster_kms](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_security_group.cluster_default](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.master](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.eks_cluster_ingress_node_http](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.eks_cluster_ingress_node_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.eks_master_ingress_bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.eks_master_ingress_internal](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.eks_master_ingress_workers_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.eks_master_ingress_workstation_https](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker_ingress_bastion](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker_ingress_cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_security_group_rule.worker_ingress_self](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [local_file.keypair_priv](https://registry.terraform.io/providers/hashicorp/local/latest/docs/resources/file) | resource |
| [tls_private_key.keypair_gen](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/resources/private_key) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_iam_policy_document.eks_sts_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.kms_policy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.worker_autoscaling_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.worker_cloudwatch_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.worker_csi_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.worker_ecr_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.worker_kms_access](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_policy_document.worker_sts_assume_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_policy_document) | data source |
| [aws_iam_role.service_role_for_autoscaling](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_iam_role.service_role_for_spot](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/iam_role) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [aws_security_group.bastion_security_group](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/security_group) | data source |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_access_cidrs"></a> [access\_cidrs](#input\_access\_cidrs) | CIDR list to allow access to EKS cluster | `list(string)` | `[]` | no |
| <a name="input_access_entries"></a> [access\_entries](#input\_access\_entries) | Additional IAM users to add IAM access Entries, aws-auth is deprecated. | `any` | `{}` | no |
| <a name="input_addons"></a> [addons](#input\_addons) | EKS Addons | `any` | `{}` | no |
| <a name="input_cluster_version"></a> [cluster\_version](#input\_cluster\_version) | Kubernetes Version for EKS setup/upgrade | `string` | `"1.20"` | no |
| <a name="input_creator_admin_permissions"></a> [creator\_admin\_permissions](#input\_creator\_admin\_permissions) | Enable admin permissions for cluster creator | `bool` | `true` | no |
| <a name="input_extend_node_user_data"></a> [extend\_node\_user\_data](#input\_extend\_node\_user\_data) | n/a | `string` | `""` | no |
| <a name="input_extra_tags"></a> [extra\_tags](#input\_extra\_tags) | n/a | `map(string)` | `{}` | no |
| <a name="input_irsa"></a> [irsa](#input\_irsa) | IRSA configuration settings | `any` | `{}` | no |
| <a name="input_is_hub"></a> [is\_hub](#input\_is\_hub) | Establish this is a HUB or spoke configuration | `bool` | `false` | no |
| <a name="input_log_group_retention"></a> [log\_group\_retention](#input\_log\_group\_retention) | Retention period for CloudWatch log groups in days | `number` | `7` | no |
| <a name="input_map_users"></a> [map\_users](#input\_map\_users) | Additional IAM users to add IAM access Entries, aws-auth is deprecated. | `any` | `[]` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Managed worker group list for EKS terraform module. | `any` | `{}` | no |
| <a name="input_node_volume_size"></a> [node\_volume\_size](#input\_node\_volume\_size) | Default Pools Node Disk Size, in GB | `number` | `30` | no |
| <a name="input_node_volume_type"></a> [node\_volume\_type](#input\_node\_volume\_type) | Default Pools Node Disk Type, gp2 \| gp3 \| io1 \| sc1 \| st1 | `string` | `"gp2"` | no |
| <a name="input_org"></a> [org](#input\_org) | n/a | <pre>object({<br/>    organization_name = string<br/>    organization_unit = string<br/>    environment_type  = string<br/>    environment_name  = string<br/>  })</pre> | n/a | yes |
| <a name="input_policy_iam_users"></a> [policy\_iam\_users](#input\_policy\_iam\_users) | IAM User lists to apply to policies | `list(string)` | `[]` | no |
| <a name="input_private_api_server"></a> [private\_api\_server](#input\_private\_api\_server) | Private API server access | `bool` | `true` | no |
| <a name="input_public_api_server"></a> [public\_api\_server](#input\_public\_api\_server) | Public API server access | `bool` | `false` | no |
| <a name="input_role_name_compat"></a> [role\_name\_compat](#input\_role\_name\_compat) | Role Name Compatibility | `bool` | `false` | no |
| <a name="input_self_node_groups"></a> [self\_node\_groups](#input\_self\_node\_groups) | Worker group list for EKS terraform module. | `any` | `{}` | no |
| <a name="input_spoke_def"></a> [spoke\_def](#input\_spoke\_def) | n/a | `string` | `"001"` | no |
| <a name="input_vpc"></a> [vpc](#input\_vpc) | VPC configuration entry | `any` | n/a | yes |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_adot_irsa_role"></a> [adot\_irsa\_role](#output\_adot\_irsa\_role) | n/a |
| <a name="output_autoscaler_irsa_role"></a> [autoscaler\_irsa\_role](#output\_autoscaler\_irsa\_role) | n/a |
| <a name="output_cert_mgr_irsa_role"></a> [cert\_mgr\_irsa\_role](#output\_cert\_mgr\_irsa\_role) | n/a |
| <a name="output_cloudwatch_irsa_role"></a> [cloudwatch\_irsa\_role](#output\_cloudwatch\_irsa\_role) | n/a |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | n/a |
| <a name="output_cluster_ca_certificate_base64"></a> [cluster\_ca\_certificate\_base64](#output\_cluster\_ca\_certificate\_base64) | n/a |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | n/a |
| <a name="output_cluster_name"></a> [cluster\_name](#output\_cluster\_name) | n/a |
| <a name="output_cluster_sg_default"></a> [cluster\_sg\_default](#output\_cluster\_sg\_default) | n/a |
| <a name="output_cluster_sg_master"></a> [cluster\_sg\_master](#output\_cluster\_sg\_master) | n/a |
| <a name="output_cluster_sg_worker"></a> [cluster\_sg\_worker](#output\_cluster\_sg\_worker) | n/a |
| <a name="output_cluster_subnet_ids"></a> [cluster\_subnet\_ids](#output\_cluster\_subnet\_ids) | n/a |
| <a name="output_ebs_csi_irsa_role"></a> [ebs\_csi\_irsa\_role](#output\_ebs\_csi\_irsa\_role) | n/a |
| <a name="output_efs_csi_irsa_role"></a> [efs\_csi\_irsa\_role](#output\_efs\_csi\_irsa\_role) | n/a |
| <a name="output_eks_worker_key"></a> [eks\_worker\_key](#output\_eks\_worker\_key) | n/a |
| <a name="output_ext_dns_irsa_role"></a> [ext\_dns\_irsa\_role](#output\_ext\_dns\_irsa\_role) | n/a |
| <a name="output_keda_irsa_role"></a> [keda\_irsa\_role](#output\_keda\_irsa\_role) | n/a |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | n/a |
| <a name="output_kms_key_id"></a> [kms\_key\_id](#output\_kms\_key\_id) | n/a |
| <a name="output_kms_key_name"></a> [kms\_key\_name](#output\_kms\_key\_name) | n/a |
| <a name="output_lb_irsa_role"></a> [lb\_irsa\_role](#output\_lb\_irsa\_role) | n/a |
| <a name="output_prometheus_irsa_role"></a> [prometheus\_irsa\_role](#output\_prometheus\_irsa\_role) | n/a |
| <a name="output_s3_csi_irsa_role"></a> [s3\_csi\_irsa\_role](#output\_s3\_csi\_irsa\_role) | n/a |
| <a name="output_secrets_store_irsa_role"></a> [secrets\_store\_irsa\_role](#output\_secrets\_store\_irsa\_role) | n/a |
| <a name="output_velero_irsa_role"></a> [velero\_irsa\_role](#output\_velero\_irsa\_role) | n/a |
| <a name="output_vpc_cni_irsa_role"></a> [vpc\_cni\_irsa\_role](#output\_vpc\_cni\_irsa\_role) | n/a |
