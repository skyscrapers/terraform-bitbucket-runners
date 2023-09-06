resource "kubernetes_service" "bitbucket_runner" {
  for_each = var.bitbucket_runners

  metadata {
    name      = "bitbucket-${each.key}"
    namespace = var.k8s_namespace

    labels = merge(var.k8s_labels, {
      "app.kubernetes.io/name"     = "bitbucket-runner"
      "app.kubernetes.io/instance" = each.key
    })
  }

  spec {
    selector = {
      "app.kubernetes.io/name"     = "bitbucket-runner"
      "app.kubernetes.io/instance" = each.key
    }

    port {
      port = 9999
    }
  }
}
