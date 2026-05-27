<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
| ---- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.6 |
| <a name="requirement_aws"></a> [aws](#requirement\_aws) | ~> 5.0 |
| <a name="requirement_tls"></a> [tls](#requirement\_tls) | ~> 4.0 |

## Providers

| Name | Version |
| ---- | ------- |
| <a name="provider_aws"></a> [aws](#provider\_aws) | ~> 5.0 |
| <a name="provider_tls"></a> [tls](#provider\_tls) | ~> 4.0 |

## Modules

No modules.

## Resources

| Name | Type |
| ---- | ---- |
| [aws_cloudwatch_log_group.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/cloudwatch_log_group) | resource |
| [aws_eks_addon.coredns](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.kube_proxy](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_addon.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_addon) | resource |
| [aws_eks_cluster.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_cluster) | resource |
| [aws_eks_node_group.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/eks_node_group) | resource |
| [aws_iam_openid_connect_provider.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_openid_connect_provider) | resource |
| [aws_iam_role.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.cluster_eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.cluster_vpc_resource](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.ebs_csi](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_ecr](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_ssm](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.node_worker](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_iam_role_policy_attachment.vpc_cni](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_kms_alias.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_alias) | resource |
| [aws_kms_key.eks](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/kms_key) | resource |
| [aws_launch_template.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/launch_template) | resource |
| [aws_security_group.cluster](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group.node](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group) | resource |
| [aws_security_group_rule.cluster_to_nodes](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/security_group_rule) | resource |
| [aws_caller_identity.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/caller_identity) | data source |
| [aws_region.current](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/region) | data source |
| [tls_certificate.eks](https://registry.terraform.io/providers/hashicorp/tls/latest/docs/data-sources/certificate) | data source |

## Inputs

| Name | Description | Type | Default | Required |
| ---- | ----------- | ---- | ------- | :------: |
| <a name="input_cluster_endpoint_private_access"></a> [cluster\_endpoint\_private\_access](#input\_cluster\_endpoint\_private\_access) | Enable private API server endpoint (recommended for production). | `bool` | `true` | no |
| <a name="input_cluster_endpoint_public_access"></a> [cluster\_endpoint\_public\_access](#input\_cluster\_endpoint\_public\_access) | Enable public API server endpoint. Disable for air-gapped / VPN-only access. | `bool` | `false` | no |
| <a name="input_cluster_endpoint_public_access_cidrs"></a> [cluster\_endpoint\_public\_access\_cidrs](#input\_cluster\_endpoint\_public\_access\_cidrs) | CIDRs allowed to reach the public endpoint. Ignored when public access is disabled. | `list(string)` | `[]` | no |
| <a name="input_cluster_log_retention_days"></a> [cluster\_log\_retention\_days](#input\_cluster\_log\_retention\_days) | Retention period in days for EKS control plane logs. | `number` | `90` | no |
| <a name="input_cluster_log_types"></a> [cluster\_log\_types](#input\_cluster\_log\_types) | EKS control plane log types to send to CloudWatch. | `list(string)` | <pre>[<br/>  "api",<br/>  "audit",<br/>  "authenticator",<br/>  "controllerManager",<br/>  "scheduler"<br/>]</pre> | no |
| <a name="input_cluster_name"></a> [cluster\_name](#input\_cluster\_name) | EKS cluster name. Must be unique within the AWS account and region. | `string` | n/a | yes |
| <a name="input_enable_cluster_encryption"></a> [enable\_cluster\_encryption](#input\_enable\_cluster\_encryption) | Encrypt Kubernetes secrets at rest using a dedicated KMS key. | `bool` | `true` | no |
| <a name="input_enable_coredns"></a> [enable\_coredns](#input\_enable\_coredns) | Install the CoreDNS managed add-on. | `bool` | `true` | no |
| <a name="input_enable_ebs_csi_driver"></a> [enable\_ebs\_csi\_driver](#input\_enable\_ebs\_csi\_driver) | Install the EBS CSI driver managed add-on. Required for PersistentVolumes backed by EBS. | `bool` | `true` | no |
| <a name="input_enable_irsa"></a> [enable\_irsa](#input\_enable\_irsa) | Create an OIDC provider for IAM Roles for Service Accounts (IRSA). Required for AWS-managed add-ons like VPC CNI, EBS CSI, and Load Balancer Controller. | `bool` | `true` | no |
| <a name="input_enable_kube_proxy"></a> [enable\_kube\_proxy](#input\_enable\_kube\_proxy) | Install the kube-proxy managed add-on. | `bool` | `true` | no |
| <a name="input_enable_vpc_cni"></a> [enable\_vpc\_cni](#input\_enable\_vpc\_cni) | Install the AWS VPC CNI managed add-on. | `bool` | `true` | no |
| <a name="input_kms_key_deletion_window_days"></a> [kms\_key\_deletion\_window\_days](#input\_kms\_key\_deletion\_window\_days) | KMS key deletion window (7-30 days). | `number` | `30` | no |
| <a name="input_kubernetes_version"></a> [kubernetes\_version](#input\_kubernetes\_version) | Kubernetes version for the EKS cluster. Patch version is managed by AWS. | `string` | `"1.30"` | no |
| <a name="input_node_groups"></a> [node\_groups](#input\_node\_groups) | Map of managed node groups. Each key becomes the node group name suffix.<br/>Example:<br/>{<br/>  "system" = { instance\_types = ["m6i.large"], min\_size = 2, desired\_size = 2, max\_size = 4 }<br/>  "workload" = { instance\_types = ["r6i.2xlarge"], min\_size = 0, desired\_size = 1, max\_size = 10 }<br/>} | <pre>map(object({<br/>    instance_types = list(string)<br/>    min_size       = number<br/>    desired_size   = number<br/>    max_size       = number<br/>    disk_size_gb   = optional(number, 50)<br/>    labels         = optional(map(string), {})<br/>    taints = optional(list(object({<br/>      key    = string<br/>      value  = string<br/>      effect = string<br/>    })), [])<br/>    # Subnet override — useful for placing spot pools in specific AZs<br/>    subnet_ids = optional(list(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_subnet_ids"></a> [subnet\_ids](#input\_subnet\_ids) | Subnet IDs for the cluster. Use private subnets for node groups; include at least one public subnet if you need an internet-facing load balancer. | `list(string)` | n/a | yes |
| <a name="input_tags"></a> [tags](#input\_tags) | Additional tags to apply to all resources. | `map(string)` | `{}` | no |
| <a name="input_vpc_id"></a> [vpc\_id](#input\_vpc\_id) | VPC ID in which to create the cluster. | `string` | n/a | yes |

## Outputs

| Name | Description |
| ---- | ----------- |
| <a name="output_cluster_arn"></a> [cluster\_arn](#output\_cluster\_arn) | EKS cluster ARN. |
| <a name="output_cluster_certificate_authority_data"></a> [cluster\_certificate\_authority\_data](#output\_cluster\_certificate\_authority\_data) | Base64-encoded CA certificate. Use with kubectl or Helm providers. |
| <a name="output_cluster_endpoint"></a> [cluster\_endpoint](#output\_cluster\_endpoint) | Kubernetes API server endpoint. |
| <a name="output_cluster_id"></a> [cluster\_id](#output\_cluster\_id) | EKS cluster ID (same as name). |
| <a name="output_cluster_version"></a> [cluster\_version](#output\_cluster\_version) | Kubernetes version running on the cluster. |
| <a name="output_kms_key_arn"></a> [kms\_key\_arn](#output\_kms\_key\_arn) | KMS key ARN used for secret encryption. Also used for EBS volume encryption in launch templates. |
| <a name="output_kubeconfig_command"></a> [kubeconfig\_command](#output\_kubeconfig\_command) | Run this command to configure kubectl for the new cluster. |
| <a name="output_node_iam_role_arn"></a> [node\_iam\_role\_arn](#output\_node\_iam\_role\_arn) | IAM role ARN for node groups. |
| <a name="output_node_iam_role_name"></a> [node\_iam\_role\_name](#output\_node\_iam\_role\_name) | IAM role name for node groups. Attach additional policies here for workloads that don't use IRSA. |
| <a name="output_node_security_group_id"></a> [node\_security\_group\_id](#output\_node\_security\_group\_id) | Security group ID for node groups. Add ingress rules here for in-cluster services. |
| <a name="output_oidc_provider_arn"></a> [oidc\_provider\_arn](#output\_oidc\_provider\_arn) | OIDC provider ARN for IRSA. Use as the federated principal in service account IAM trust policies. |
| <a name="output_oidc_provider_url"></a> [oidc\_provider\_url](#output\_oidc\_provider\_url) | OIDC provider URL (without https://) for building trust policy conditions. |
<!-- END_TF_DOCS -->