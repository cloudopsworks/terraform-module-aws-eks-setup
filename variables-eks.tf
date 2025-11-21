##
# (c) 2021-2025
#     Cloud Ops Works LLC - https://cloudops.works/
#     Find us on:
#       GitHub: https://github.com/cloudopsworks
#       WebSite: https://cloudops.works
#     Distributed Under Apache v2.0 License
#

variable "vpc" {
  description = "VPC configuration entry"
  type        = any
}

variable "extend_node_user_data" {
  default = ""
}

# DEPRECATED
variable "map_users" {
  description = "Additional IAM users to add IAM access Entries, aws-auth is deprecated."
  type        = any
  default     = []
}

variable "access_entries" {
  description = "Additional IAM users to add IAM access Entries, aws-auth is deprecated."
  type        = any
  default     = {}
}

variable "node_groups" {
  description = "Managed worker group list for EKS terraform module."
  type        = any
  default     = {}
}

variable "self_node_groups" {
  description = "Worker group list for EKS terraform module."
  type        = any
  default     = {}
}

variable "cluster_version" {
  description = "Kubernetes Version for EKS setup/upgrade"
  type        = string
  default     = "1.20"
}

variable "policy_iam_users" {
  description = "IAM User lists to apply to policies"
  type        = list(string)
  default     = []
}

variable "access_cidrs" {
  description = "CIDR list to allow access to EKS cluster"
  type        = list(string)
  default     = []
}

variable "irsa" {
  description = "IRSA configuration settings"
  type        = any
  default     = {}
}

variable "public_api_server" {
  description = "Public API server access"
  type        = bool
  default     = false
}

variable "private_api_server" {
  description = "Private API server access"
  type        = bool
  default     = true
}

variable "node_volume_size" {
  description = "Default Pools Node Disk Size, in GB"
  type        = number
  default     = 30
}

variable "node_volume_type" {
  description = "Default Pools Node Disk Type, gp2 | gp3 | io1 | sc1 | st1"
  type        = string
  default     = "gp2"
}

variable "role_name_compat" {
  description = "Role Name Compatibility"
  type        = bool
  default     = false
}

variable "addons" {
  description = "EKS Addons"
  type        = any
  default     = {}
}

variable "log_group_retention" {
  description = "Retention period for CloudWatch log groups in days"
  type        = number
  default     = 7
}