variable "environment" {
  type = string
}

variable "bitbucket_runners" {
  type = map(object({
    resources = optional(object({
      limits = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
      requests = optional(object({
        cpu    = optional(string)
        memory = optional(string)
      }))
    }))
  }))
  description = "Map of Bitbucket runner definitions"
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

variable "pod_default_resources" {
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
  description = "Default resources that will be applied to all runner Pods, unless overriden in the runner definition"
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
