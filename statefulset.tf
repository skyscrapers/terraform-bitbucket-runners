resource "kubernetes_stateful_set" "bitbucket_runner" {
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
    selector {
      match_labels = {
        "app.kubernetes.io/name"     = "bitbucket-runner"
        "app.kubernetes.io/instance" = each.key
      }
    }

    service_name = kubernetes_service.bitbucket_runner[each.key].metadata[0].name

    template {
      metadata {
        labels = {
          "app.kubernetes.io/name"     = "bitbucket-runner"
          "app.kubernetes.io/instance" = each.key
        }
      }

      spec {
        node_selector        = var.k8s_node_selector
        service_account_name = kubernetes_service_account.bitbucket_runner.metadata.0.name

        dynamic "toleration" {
          for_each = var.k8s_tolerations

          content {
            effect = toleration.value.effect
            key    = toleration.value.key
            value  = toleration.value.value
          }
        }

        affinity {
          pod_anti_affinity {
            required_during_scheduling_ignored_during_execution {
              label_selector {
                match_labels = {
                  "app.kubernetes.io/name" = "bitbucket-runner"
                }
              }
              topology_key = "kubernetes.io/hostname"
            }
          }
        }

        container {
          image = "docker-public.packages.atlassian.com/sox/atlassian/bitbucket-pipelines-runner:${var.runner_version}"
          name  = "runner"

          env {
            name = "ACCOUNT_UUID"

            value_from {
              secret_key_ref {
                name = "runners-accountid"
                key  = "accountUuid"
              }
            }
          }

          env {
            name = "REPOSITORY_UUID"

            value_from {
              secret_key_ref {
                name     = "${each.key}-credentials"
                key      = "repositoryUuid"
                optional = true
              }
            }
          }

          env {
            name = "RUNNER_UUID"

            value_from {
              secret_key_ref {
                name = "${each.key}-credentials"
                key  = "runnerUuid"
              }
            }
          }

          env {
            name = "OAUTH_CLIENT_ID"

            value_from {
              secret_key_ref {
                name = "${each.key}-credentials"
                key  = "oauthClientId"
              }
            }
          }

          env {
            name = "OAUTH_CLIENT_SECRET"

            value_from {
              secret_key_ref {
                name = "${each.key}-credentials"
                key  = "oauthClientSecret"
              }
            }
          }

          env {
            name  = "WORKING_DIRECTORY"
            value = "/tmp"
          }

          env {
            name  = "RUNTIME_PREREQUISITES_ENABLED"
            value = "true"
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "docker-containers"
            mount_path = "/var/lib/docker/containers"
            read_only  = true
          }

          volume_mount {
            name       = "var-run"
            mount_path = "/var/run"
          }

          resources {
            limits = {
              cpu    = try(each.value.runner_resources.limits.cpu, var.bitbucket_runner_container_default_resources.limits.cpu, null)
              memory = try(each.value.runner_resources.limits.memory, var.bitbucket_runner_container_default_resources.limits.memory, null)
            }

            requests = {
              cpu    = try(each.value.runner_resources.requests.cpu, var.bitbucket_runner_container_default_resources.requests.cpu, null)
              memory = try(each.value.runner_resources.requests.memory, var.bitbucket_runner_container_default_resources.requests.memory, null)
            }
          }
        }

        container {
          image = "public.ecr.aws/docker/library/docker:20.10.5-dind"
          name  = "docker-in-docker"

          security_context {
            privileged = true
          }

          volume_mount {
            name       = "tmp"
            mount_path = "/tmp"
          }

          volume_mount {
            name       = "docker-containers"
            mount_path = "/var/lib/docker/containers"
          }

          volume_mount {
            name       = "var-run"
            mount_path = "/var/run"
          }

          resources {
            limits = {
              cpu    = try(each.value.dind_resources.limits.cpu, var.dind_container_default_resources.limits.cpu, null)
              memory = try(each.value.dind_resources.limits.memory, var.dind_container_default_resources.limits.memory, null)
            }

            requests = {
              cpu    = try(each.value.dind_resources.requests.cpu, var.dind_container_default_resources.requests.cpu, null)
              memory = try(each.value.dind_resources.requests.memory, var.dind_container_default_resources.requests.memory, null)
            }
          }
        }

        volume {
          name = "tmp"
          empty_dir {}
        }

        volume {
          name = "docker-containers"
          empty_dir {}
        }

        volume {
          name = "var-run"
          empty_dir {}
        }
      }
    }
  }
}
