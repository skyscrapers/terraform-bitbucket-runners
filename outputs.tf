output "kubernetes_service_account_name" {
  value = kubernetes_service_account.bitbucket_runner.metadata.0.name
}
