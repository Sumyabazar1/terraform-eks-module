output "cluster_id" {
  value       = aws_eks_cluster.this.id
  description = "EKS cluster ID (same as name)."
}

output "cluster_arn" {
  value       = aws_eks_cluster.this.arn
  description = "EKS cluster ARN."
}

output "cluster_endpoint" {
  value       = aws_eks_cluster.this.endpoint
  description = "Kubernetes API server endpoint."
}

output "cluster_certificate_authority_data" {
  value       = aws_eks_cluster.this.certificate_authority[0].data
  sensitive   = true
  description = "Base64-encoded CA certificate. Use with kubectl or Helm providers."
}

output "cluster_version" {
  value       = aws_eks_cluster.this.version
  description = "Kubernetes version running on the cluster."
}

output "oidc_provider_arn" {
  value       = var.enable_irsa ? aws_iam_openid_connect_provider.eks[0].arn : null
  description = "OIDC provider ARN for IRSA. Use as the federated principal in service account IAM trust policies."
}

output "oidc_provider_url" {
  value       = var.enable_irsa ? trimprefix(aws_eks_cluster.this.identity[0].oidc[0].issuer, "https://") : null
  description = "OIDC provider URL (without https://) for building trust policy conditions."
}

output "node_security_group_id" {
  value       = aws_security_group.node.id
  description = "Security group ID for node groups. Add ingress rules here for in-cluster services."
}

output "node_iam_role_name" {
  value       = aws_iam_role.node.name
  description = "IAM role name for node groups. Attach additional policies here for workloads that don't use IRSA."
}

output "node_iam_role_arn" {
  value       = aws_iam_role.node.arn
  description = "IAM role ARN for node groups."
}

output "kms_key_arn" {
  value       = var.enable_cluster_encryption ? aws_kms_key.eks[0].arn : null
  description = "KMS key ARN used for secret encryption. Also used for EBS volume encryption in launch templates."
}

output "kubeconfig_command" {
  value       = "aws eks update-kubeconfig --region ${data.aws_region.current.name} --name ${var.cluster_name}"
  description = "Run this command to configure kubectl for the new cluster."
}
