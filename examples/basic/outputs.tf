output "cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "kubeconfig_command" {
  value = module.eks.kubeconfig_command
}

output "oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}
