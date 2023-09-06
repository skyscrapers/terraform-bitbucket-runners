resource "kubernetes_service_account" "bitbucket_runner" {
  metadata {
    name      = "bitbucket-runner"
    namespace = var.k8s_namespace

    labels = merge(local.k8s_default_labels, {
      "app.kubernetes.io/name" = "bitbucket-runner"
    })

    annotations = var.k8s_service_account_annotations
  }
}
