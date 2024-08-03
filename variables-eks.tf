##
# (c) 2024 - Cloud Ops Works LLC - https://cloudops.works/
#            On GitHub: https://github.com/cloudopsworks
#            Distributed Under Apache v2.0 License
#

variable "vpc" {
  description = "VPC configuration entry"
  type        = any
}

variable "extend_node_user_data" {
  default = ""
}

variable "map_users" {
  description = "Additional IAM users to add to the aws-auth configmap."
  type        = list(any)
}

variable "map_roles" {
  description = "Additional IAM ROLES to add to the aws-auth configmap."
  type        = list(any)
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