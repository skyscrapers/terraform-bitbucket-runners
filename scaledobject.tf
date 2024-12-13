resource "kubernetes_manifest" "scaledobject_cron" {
  for_each = {
    for runner_name, runner_config in var.bitbucket_runners : runner_name => runner_config
    if lookup(runner_config, "cron_scaling_enabled", false)
  }

  manifest = {
    "apiVersion" = "keda.sh/v1alpha1"
    "kind"       = "ScaledObject"
    "metadata"   = {
      "name"      = "bitbucket-${each.key}"
      "namespace" = var.k8s_namespace
    }
    
    "spec" = {
      "scaleTargetRef" = {
        "name" = "bitbucket-${each.key}"
      }
      "minReplicaCount" = 0
      "maxReplicaCount" = 1
      "triggers" = [
        {
          "type"     = "cron"
          "metadata" = {
            "timeZone"        = lookup(each.value, "timeZone", "UTC")
            "schedule"        = lookup(each.value, "working_hours", "0 6-23 * * 1-5")
            "desiredReplicas" = "1"
          }
        },
        {
          "type"     = "cron"
          "metadata" = {
            "timeZone"        = lookup(each.value, "timeZone", "UTC")
            "schedule"        = lookup(each.value, "non_working_hours_weekdays", "0 0-5,23 * * 1-5")
            "desiredReplicas" = "0"
          }
        },
        {
          "type"     = "cron"
          "metadata" = {
            "timeZone"        = lookup(each.value, "timeZone", "UTC")
            "schedule"        = lookup(each.value, "non_working_days", "0 0-23 * * 6-7")
            "desiredReplicas" = "0"
          }
        }
      ]
    }
  }
}
