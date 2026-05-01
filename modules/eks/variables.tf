variable "cluster_name" {
  type        = string
  description = "EKS cluster name. Must be unique within the AWS account and region."
  validation {
    condition     = can(regex("^[a-zA-Z][a-zA-Z0-9-]{0,99}$", var.cluster_name))
    error_message = "Cluster name must start with a letter and contain only alphanumerics and hyphens (max 100 chars)."
  }
}

variable "kubernetes_version" {
  type        = string
  default     = "1.30"
  description = "Kubernetes version for the EKS cluster. Patch version is managed by AWS."
}

variable "vpc_id" {
  type        = string
  description = "VPC ID in which to create the cluster."
}

variable "subnet_ids" {
  type        = list(string)
  description = "Subnet IDs for the cluster. Use private subnets for node groups; include at least one public subnet if you need an internet-facing load balancer."
}

variable "cluster_endpoint_private_access" {
  type        = bool
  default     = true
  description = "Enable private API server endpoint (recommended for production)."
}

variable "cluster_endpoint_public_access" {
  type        = bool
  default     = false
  description = "Enable public API server endpoint. Disable for air-gapped / VPN-only access."
}

variable "cluster_endpoint_public_access_cidrs" {
  type        = list(string)
  default     = []
  description = "CIDRs allowed to reach the public endpoint. Ignored when public access is disabled."
}

variable "cluster_log_types" {
  type        = list(string)
  default     = ["api", "audit", "authenticator", "controllerManager", "scheduler"]
  description = "EKS control plane log types to send to CloudWatch."
}

variable "cluster_log_retention_days" {
  type        = number
  default     = 90
  description = "Retention period in days for EKS control plane logs."
}

variable "node_groups" {
  type = map(object({
    instance_types = list(string)
    min_size       = number
    desired_size   = number
    max_size       = number
    disk_size_gb   = optional(number, 50)
    labels         = optional(map(string), {})
    taints = optional(list(object({
      key    = string
      value  = string
      effect = string
    })), [])
    # Subnet override — useful for placing spot pools in specific AZs
    subnet_ids = optional(list(string), [])
  }))
  default     = {}
  description = <<-EOT
    Map of managed node groups. Each key becomes the node group name suffix.
    Example:
    {
      "system" = { instance_types = ["m6i.large"], min_size = 2, desired_size = 2, max_size = 4 }
      "workload" = { instance_types = ["r6i.2xlarge"], min_size = 0, desired_size = 1, max_size = 10 }
    }
  EOT
}

variable "enable_irsa" {
  type        = bool
  default     = true
  description = "Create an OIDC provider for IAM Roles for Service Accounts (IRSA). Required for AWS-managed add-ons like VPC CNI, EBS CSI, and Load Balancer Controller."
}

variable "enable_cluster_encryption" {
  type        = bool
  default     = true
  description = "Encrypt Kubernetes secrets at rest using a dedicated KMS key."
}

variable "kms_key_deletion_window_days" {
  type        = number
  default     = 30
  description = "KMS key deletion window (7-30 days)."
  validation {
    condition     = var.kms_key_deletion_window_days >= 7 && var.kms_key_deletion_window_days <= 30
    error_message = "KMS deletion window must be between 7 and 30 days."
  }
}

variable "enable_ebs_csi_driver" {
  type        = bool
  default     = true
  description = "Install the EBS CSI driver managed add-on. Required for PersistentVolumes backed by EBS."
}

variable "enable_vpc_cni" {
  type        = bool
  default     = true
  description = "Install the AWS VPC CNI managed add-on."
}

variable "enable_coredns" {
  type        = bool
  default     = true
  description = "Install the CoreDNS managed add-on."
}

variable "enable_kube_proxy" {
  type        = bool
  default     = true
  description = "Install the kube-proxy managed add-on."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "Additional tags to apply to all resources."
}
