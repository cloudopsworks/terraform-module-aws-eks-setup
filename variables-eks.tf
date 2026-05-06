##
# (c) 2021-2026
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

# vpc:                                # (Required) VPC configuration used by the EKS control plane and worker nodes.
#   vpc_id: "vpc-0123456789abcdef0"   # (Required) Existing VPC ID where the cluster security groups and nodes are created.
#   private_subnets: []                # (Required) Private or intra subnet IDs used by the cluster and node groups.
#   ssh_admin_security_group_id: ""    # (Required) Security group ID allowed to reach the cluster and worker SSH rules.
#   local_network_cidrs: []            # (Optional) CIDR blocks allowed to reach the private API endpoint. Default: [].
#   vpn_accesses: []                   # (Optional) Workstation or VPN CIDR blocks allowed to reach the API endpoint. Default: [].
variable "vpc" {
  description = "VPC configuration entry. Requires vpc_id, private_subnets, ssh_admin_security_group_id, and optional local_network_cidrs/vpn_accesses."
  type        = any
}

# extend_node_user_data: "" # (Optional) Extra user-data snippet reserved for node bootstrap customizations. Default: "".
variable "extend_node_user_data" {
  description = "Extra user-data snippet reserved for node bootstrap customizations."
  type        = string
  default     = ""
}

# DEPRECATED
# map_users: []                         # (Optional) Deprecated aws-auth style user mappings. Default: [].
#   - username: "platform-admin"        # (Required) Kubernetes username for the mapped IAM user.
#     userarn: "arn:aws:iam::123456789012:user/platform-admin" # (Required) IAM user ARN.
#     policy_arn: "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy" # (Required) EKS access policy ARN.
#     namespaces: []                    # (Optional) Namespace scope list. Empty list means cluster scope. Default: [].
#     type: "STANDARD"                  # (Optional) EKS access entry type. Valid values: STANDARD, EC2_LINUX, EC2_WINDOWS, FARGATE_LINUX. Default: STANDARD.
variable "map_users" {
  description = "DEPRECATED. Additional IAM users converted to EKS access entries; aws-auth is deprecated."
  type        = any
  default     = []
}

# access_entries: {}                    # (Optional) Additional EKS access entries keyed by logical name. Default: {}.
#   admin:
#     principal_arn: "arn:aws:iam::123456789012:role/platform-admin" # (Required) IAM principal ARN granted cluster access.
#     type: "STANDARD"                  # (Optional) EKS access entry type. Valid values: STANDARD, EC2_LINUX, EC2_WINDOWS, FARGATE_LINUX. Default: STANDARD.
#     kubernetes_groups: []             # (Optional) Kubernetes RBAC groups for this principal. Default: null.
#     user_name: ""                     # (Optional) Kubernetes username override. Default: null.
#     tags: {}                          # (Optional) Tags applied to the access entry. Default: {}.
#     policy_associations: {}           # (Optional) EKS access policy associations keyed by name. Default: {}.
#       admin:
#         policy_arn: "arn:aws:eks::aws:cluster-access-policy/AmazonEKSClusterAdminPolicy" # (Required) EKS cluster access policy ARN.
#         access_scope:
#           type: "cluster"             # (Required) Access scope type. Valid values: cluster, namespace.
#           namespaces: []              # (Optional) Namespace list when type is namespace. Default: null.
variable "access_entries" {
  description = "Additional EKS access entries keyed by logical name."
  type        = any
  default     = {}
}

# node_groups: {}                       # (Optional) EKS managed node groups keyed by logical name. Default: {}.
#   default:
#     desired_size: 2                   # (Optional) Desired managed node count. Default: upstream module default.
#     min_size: 1                       # (Optional) Minimum managed node count. Default: upstream module default.
#     max_size: 5                       # (Optional) Maximum managed node count. Default: upstream module default.
#     instance_types: ["m6i.large"]     # (Optional) EC2 instance type list. Default: module node group defaults.
#     capacity_type: "ON_DEMAND"        # (Optional) Capacity type. Valid values: ON_DEMAND, SPOT. Default: ON_DEMAND.
#     ami_type: "AL2023_x86_64_STANDARD" # (Optional) Managed node AMI type supported by EKS. Default: upstream module default.
#     disk_size: 50                     # (Optional) Root volume size in GB when not using block_device_mappings. Default: module node group defaults.
#     subnet_ids: []                    # (Optional) Subnet IDs for this group. Default: vpc.private_subnets.
#     labels: {}                        # (Optional) Kubernetes labels for nodes. Default: {}.
#     taints: {}                        # (Optional) Kubernetes taints for nodes. Default: {}.
#     update_config: {}                 # (Optional) Managed node update configuration. Default: upstream module default.
#     iam_role_additional_policies: {}  # (Optional) Additional IAM policy ARNs attached to the node role. Default: {}.
variable "node_groups" {
  description = "Managed worker group map for the upstream EKS Terraform module."
  type        = any
  default     = {}
}

# self_node_groups: {}                  # (Optional) Self-managed node groups keyed by logical name. Default: {}.
#   default:
#     desired_capacity: 2               # (Optional) Desired Auto Scaling Group capacity. Default: upstream module default.
#     min_size: 1                       # (Optional) Minimum Auto Scaling Group capacity. Default: upstream module default.
#     max_size: 5                       # (Optional) Maximum Auto Scaling Group capacity. Default: upstream module default.
#     instance_type: "m6i.large"        # (Optional) EC2 instance type. Default: module self-managed defaults.
#     instance_types: ["m6i.large"]     # (Optional) Mixed-instance type list. Default: module self-managed defaults.
#     ami_type: "AL2023_x86_64_STANDARD" # (Optional) AMI family/type supported by the upstream module. Default: upstream module default.
#     key_name: ""                      # (Optional) SSH key pair name. Default: module-generated key pair.
#     subnet_ids: []                    # (Optional) Subnet IDs for this group. Default: vpc.private_subnets.
#     enable_monitoring: true           # (Optional) Enable detailed monitoring. Default: upstream module default.
#     iam_role_additional_policies: []  # (Optional) Additional IAM policy ARNs attached to the node role. Default: module self-managed defaults.
#     bootstrap_user_data: ""           # (Optional) Bootstrap user-data content. Default: upstream module default.
variable "self_node_groups" {
  description = "Self-managed worker group map for the upstream EKS Terraform module."
  type        = any
  default     = {}
}

# cluster_version: "1.30" # (Optional) Kubernetes version for EKS setup or upgrade. Default: "1.20".
variable "cluster_version" {
  description = "Kubernetes version for EKS setup or upgrade."
  type        = string
  default     = "1.20"
}

# policy_iam_users: [] # (Optional) IAM principal ARNs granted KMS key administration permissions. Default: [].
variable "policy_iam_users" {
  description = "IAM principal ARN list to add as KMS key administrators."
  type        = list(string)
  default     = []
}

# access_cidrs: [] # (Optional) CIDR list allowed to access the public EKS API endpoint. Default: [].
variable "access_cidrs" {
  description = "CIDR list allowed to access the public EKS API endpoint."
  type        = list(string)
  default     = []
}

# irsa: {}                              # (Optional) IAM Roles for Service Accounts configuration. Default: {}.
#   vpc_cni:                            # (Optional) AWS VPC CNI IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the VPC CNI IRSA role. Default: false.
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   lb:                                 # (Optional) AWS Load Balancer Controller IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the load balancer controller IRSA role. Default: false.
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   ebs_csi:                            # (Optional) AWS EBS CSI driver IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the EBS CSI IRSA role. Default: false.
#     kms_cmk_ids: []                   # (Optional) Additional KMS CMK ARNs allowed by the EBS CSI policy. Default: [].
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   efs_csi:                            # (Optional) AWS EFS CSI driver IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the EFS CSI IRSA role. Default: false.
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   external_dns:                       # (Optional) ExternalDNS IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the ExternalDNS IRSA role. Default: false.
#     hosted_zone_arns: []              # (Optional) Route53 hosted zone ARNs managed by ExternalDNS. Default: [].
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   cluster_autoscaler:                 # (Optional) Cluster Autoscaler IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the Cluster Autoscaler IRSA role. Default: false.
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   cert_manager:                       # (Optional) cert-manager IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the cert-manager IRSA role. Default: false.
#     hosted_zone_arns: []              # (Optional) Route53 hosted zone ARNs for DNS validation. Default: [].
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   s3_csi:                             # (Optional) Mountpoint for Amazon S3 CSI IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the S3 CSI IRSA role. Default: false.
#     bucket_arns: []                   # (Optional) S3 bucket ARNs allowed by the CSI policy. Default: [].
#     kms_arns: []                      # (Optional) KMS key ARNs allowed by the CSI policy. Default: [].
#     path_arns: []                     # (Optional) S3 path ARNs allowed by the CSI policy. Default: [].
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   velero:                             # (Optional) Velero IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the Velero IRSA role. Default: false.
#     bucket_arns: []                   # (Optional) Backup bucket ARNs. Default: [].
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   prometheus:                         # (Optional) Amazon Managed Service for Prometheus IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the Prometheus IRSA role. Default: false.
#     workspace_arns: []                # (Optional) AMP workspace ARNs. Default: [].
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   cloudwatch:                         # (Optional) CloudWatch Observability IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the CloudWatch IRSA role. Default: false.
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   secrets_store:                      # (Optional) Secrets Store CSI driver IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the Secrets Store IRSA role. Default: false.
#     secrets_manager_arns: []          # (Optional) AWS Secrets Manager secret ARNs. Default: [].
#     secrets_manager_create_permission: false # (Optional) Allow creating Secrets Manager secrets. Default: false.
#     ssm_parameter_arns: []            # (Optional) SSM parameter ARNs. Default: [].
#     kms_key_arns: []                  # (Optional) KMS key ARNs used by secrets or parameters. Default: [].
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   adot:                               # (Optional) AWS Distro for OpenTelemetry IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the ADOT IRSA role. Default: false.
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
#   keda:                               # (Optional) KEDA IRSA role configuration. Default: disabled.
#     enabled: false                    # (Optional) Create/use the KEDA IRSA role. Default: false.
#     namespace_service_accounts: []    # (Optional) namespace:service_account bindings. Default: [].
#     role_policy_arns: {}              # (Optional) Extra IAM policy ARNs. Default: {}.
variable "irsa" {
  description = "IRSA configuration settings for supported EKS controllers and CSI drivers."
  type        = any
  default     = {}
}

# public_api_server: false # (Optional) Enable public access to the EKS API server endpoint. Default: false.
variable "public_api_server" {
  description = "Enable public access to the EKS API server endpoint."
  type        = bool
  default     = false
}

# private_api_server: true # (Optional) Enable private access to the EKS API server endpoint. Default: true.
variable "private_api_server" {
  description = "Enable private access to the EKS API server endpoint."
  type        = bool
  default     = true
}

# node_volume_size: 30 # (Optional) Default root EBS volume size, in GB, for node groups. Default: 30.
variable "node_volume_size" {
  description = "Default root EBS volume size, in GB, for node groups."
  type        = number
  default     = 30
}

# node_volume_type: "gp3" # (Optional) Default root EBS volume type for node groups. Valid values include gp2, gp3, io1, io2, sc1, st1. Default: "gp3".
variable "node_volume_type" {
  description = "Default root EBS volume type for node groups."
  type        = string
  default     = "gp3"
}

# role_name_compat: false # (Optional) Use legacy control-plane IAM role naming for compatibility. Default: false.
variable "role_name_compat" {
  description = "Use legacy control-plane IAM role naming for compatibility."
  type        = bool
  default     = false
}

# addons: {}                         # (Optional) Optional EKS addon toggles layered on top of the base addons. Default: {}.
#   efs:
#     enabled: false                  # (Optional) Enable aws-efs-csi-driver addon. Default: false.
#   snapshot:
#     enabled: false                  # (Optional) Enable snapshot-controller addon. Default: false.
#   cloudwatch:
#     enabled: false                  # (Optional) Enable amazon-cloudwatch-observability addon. Default: false.
#   pod_identity:
#     enabled: false                  # (Optional) Enable eks-pod-identity-agent addon. Default: false.
#   adot:
#     enabled: false                  # (Optional) Enable AWS Distro for OpenTelemetry addon. Default: false.
variable "addons" {
  description = "Optional EKS addon toggles layered on top of the base coredns, kube-proxy, vpc-cni, and ebs-csi addons."
  type        = any
  default     = {}
}

# log_group_retention: 7 # (Optional) CloudWatch log group retention period in days for EKS control-plane logs. Default: 7.
variable "log_group_retention" {
  description = "CloudWatch log group retention period in days for EKS control-plane logs."
  type        = number
  default     = 7
}

# creator_admin_permissions: true # (Optional) Grant the Terraform caller cluster administrator access through an EKS access entry. Default: true.
variable "creator_admin_permissions" {
  description = "Grant the Terraform caller cluster administrator access through an EKS access entry."
  type        = bool
  default     = true
  nullable    = false
}
