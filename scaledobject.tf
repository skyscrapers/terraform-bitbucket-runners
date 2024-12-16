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
        "name"       = "bitbucket-${each.key}"
        "apiVersion" = "apps/v1"
        "kind"       = "StatefulSet"
      }
      "minReplicaCount" = 0
      "maxReplicaCount" = 1
      "triggers" = [
        for trigger in lookup(each.value, "triggers", []) : {
          "type" = "cron"
          "metadata" = {
            "start"           = trigger.start
            "end"             = trigger.end
            "timezone"        = trigger.timezone
            "desiredReplicas" = tostring(trigger.desiredReplicas)
          }
        }
      ]
    }
  }
}
