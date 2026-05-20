# terraform-eks-module

A production-ready, reusable Terraform module for provisioning an AWS EKS cluster with security defaults you'd want from day one.

## Features

- **Private API server** endpoint by default (no public Kubernetes API exposure)
- **KMS encryption** for Kubernetes secrets at rest
- **IMDSv2 enforced** on all node groups (prevents SSRF → metadata credential theft)
- **IRSA** (IAM Roles for Service Accounts) — workloads get scoped IAM credentials, not node-level access
- **Managed add-ons** — VPC CNI, CoreDNS, kube-proxy, EBS CSI via the EKS add-on API (AWS manages patches)
- **Encrypted EBS volumes** on node groups using the cluster's KMS key
- **CI pipeline** — `terraform validate` + `tfsec` + `Checkov` on every PR

## Usage

```hcl
module "eks" {
  source = "github.com/sumyabazar1/terraform-eks-module//modules/eks"

  cluster_name       = "prod-cluster"
  kubernetes_version = "1.30"
  vpc_id             = "vpc-0abc123"
  subnet_ids         = ["subnet-aaa", "subnet-bbb", "subnet-ccc"]

  cluster_endpoint_private_access = true
  cluster_endpoint_public_access  = false

  enable_irsa               = true
  enable_cluster_encryption = true
  enable_ebs_csi_driver     = true

  node_groups = {
    system = {
      instance_types = ["m6i.large"]
      min_size       = 2
      desired_size   = 2
      max_size       = 4
    }
    workload = {
      instance_types = ["r6i.2xlarge"]
      min_size       = 0
      desired_size   = 2
      max_size       = 20
      labels = { role = "workload" }
    }
  }

  tags = {
    Environment = "prod"
    Team        = "platform"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| Terraform | >= 1.6 |
| AWS provider | ~> 5.0 |

## Inputs

<!-- BEGIN_TF_DOCS -->
| Name | Type | Default | Required | Description |
|------|------|---------|----------|-------------|
| `cluster_name` | `string` | — | yes | EKS cluster name. |
| `kubernetes_version` | `string` | `"1.30"` | no | Kubernetes version. |
| `vpc_id` | `string` | — | yes | VPC ID. |
| `subnet_ids` | `list(string)` | — | yes | Subnets for node groups and control plane ENIs. |
| `cluster_endpoint_private_access` | `bool` | `true` | no | Enable private API endpoint. |
| `cluster_endpoint_public_access` | `bool` | `false` | no | Enable public API endpoint. |
| `cluster_endpoint_public_access_cidrs` | `list(string)` | `[]` | no | CIDRs for public endpoint (when enabled). |
| `cluster_log_types` | `list(string)` | All 5 types | no | Control plane log types to ship to CloudWatch. |
| `cluster_log_retention_days` | `number` | `90` | no | CloudWatch log retention. |
| `node_groups` | `map(object)` | `{}` | no | Managed node group definitions (see below). |
| `enable_irsa` | `bool` | `true` | no | Create OIDC provider for IRSA. |
| `enable_cluster_encryption` | `bool` | `true` | no | Encrypt secrets with KMS. |
| `kms_key_deletion_window_days` | `number` | `30` | no | KMS key deletion window (7-30). |
| `enable_ebs_csi_driver` | `bool` | `true` | no | Install EBS CSI add-on. |
| `enable_vpc_cni` | `bool` | `true` | no | Install VPC CNI add-on. |
| `enable_coredns` | `bool` | `true` | no | Install CoreDNS add-on. |
| `enable_kube_proxy` | `bool` | `true` | no | Install kube-proxy add-on. |
| `tags` | `map(string)` | `{}` | no | Additional tags for all resources. |

### node_groups object schema

```hcl
{
  instance_types = list(string)         # Required
  min_size       = number               # Required
  desired_size   = number               # Required
  max_size       = number               # Required
  disk_size_gb   = optional(number, 50)
  labels         = optional(map(string), {})
  taints         = optional(list(object({
    key    = string
    value  = string
    effect = string                     # NO_SCHEDULE | NO_EXECUTE | PREFER_NO_SCHEDULE
  })), [])
  subnet_ids     = optional(list(string), [])  # Override subnets for this group
}
```

## Outputs

| Name | Description |
|------|-------------|
| `cluster_id` | EKS cluster ID. |
| `cluster_arn` | EKS cluster ARN. |
| `cluster_endpoint` | API server endpoint. |
| `cluster_certificate_authority_data` | Base64 CA certificate (sensitive). |
| `oidc_provider_arn` | OIDC provider ARN for IRSA trust policies. |
| `oidc_provider_url` | OIDC URL (without `https://`) for condition keys. |
| `node_security_group_id` | Node group SG — add ingress rules here. |
| `node_iam_role_arn` | Node IAM role ARN. |
| `kms_key_arn` | KMS key used for secret + EBS encryption. |
| `kubeconfig_command` | `aws eks update-kubeconfig ...` command to run. |
<!-- END_TF_DOCS -->

## Security posture

| Control | Implementation |
|---------|---------------|
| API server exposure | Private-only by default |
| Secret encryption | KMS with automatic key rotation |
| Node credentials | IMDSv2 enforced; IRSA for workloads |
| EBS encryption | Enabled on all node group volumes via launch template |
| Control plane logs | All 5 log types → CloudWatch (90-day retention) |
| Node OS access | SSM Session Manager (no public SSH) |

## CI pipeline

Every pull request runs:

1. **`terraform fmt -check`** — formatting consistency
2. **`terraform validate`** — configuration syntax and type checking
3. **[tfsec](https://github.com/aquasecurity/tfsec)** — Terraform security static analysis
4. **[Checkov](https://www.checkov.io/)** — policy-as-code checks (CIS benchmark)
5. **[terraform-docs](https://terraform-docs.io/)** — checks that documentation is up to date

SARIF results from tfsec and Checkov are uploaded to GitHub Code Scanning.

## Examples

- [**Basic**](examples/basic/) — two node groups on private subnets, all security defaults

## License

MIT
