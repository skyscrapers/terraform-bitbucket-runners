variable "k8s_labels" {
  type        = map(string)
  description = "Labels to apply to all Kubernetes objects"
  default     = {}
}

variable "bitbucket_runners" {
  type = map(object({
    runner_resources = optional(object({
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
    dind_resources = optional(object({
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
    cron_scaling_enabled       = optional(bool, false)
    timeZone                   = optional(string, "UTC")
    working_hours              = optional(string, "0 6-23 * * 1-5")
    non_working_hours_weekdays = optional(string, "0 0-5,23 * * 1-5")
    non_working_days           = optional(string, "0 0-23 * * 6-7")
  }))
  description = "Map of Bitbucket runner definitions"
}

variable "runner_version" {
  type        = number
  description = "Version of the Bitbucket runner to deploy"
  default     = 1
}

variable "k8s_namespace" {
  type        = string
  description = "Kubernetes namespace where to deploy the runners to"
}

variable "k8s_node_selector" {
  type        = map(string)
  description = "Node selector to apply to the runner StatefulSets"
  default     = null
}

variable "k8s_tolerations" {
  type = list(object({
    effect = string
    key    = string
    value  = string
  }))
  description = "Tolerations to apply to the runner StatefulSets"
  default     = []
}

variable "k8s_service_account_annotations" {
  type        = map(string)
  description = "Annotations to attach to the ServiceAccount"
  default     = {}
}

variable "bitbucket_runner_container_default_resources" {
  type = object({
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  })
  description = "Default resources that will be applied to the Bitbucket runner container of all runner Pods, unless overriden in the runner definition"
  default = {
    limits = {
      cpu    = null
      memory = "4G"
    }
    requests = {
      cpu    = 1
      memory = "1G"
    }
  }
}

variable "dind_container_default_resources" {
  type = object({
    limits = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
    requests = optional(object({
      cpu    = optional(string)
      memory = optional(string)
    }))
  })
  description = "Default resources that will be applied to the DinD container of all runner Pods, unless overriden in the runner definition"
  default = {
    limits = {
      cpu    = null
      memory = "4G"
    }
    requests = {
      cpu    = 1
      memory = "1G"
    }
  }
}
