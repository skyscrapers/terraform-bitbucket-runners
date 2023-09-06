<!-- markdownlint-disable MD033 -->

# Terraform Bitbucket Runners

This module sets up a set of Bitbucket runners on a Kubernetes cluster. It accepts a list of runner configurations and deploys a `Service` and a `StatefulSet` for each of them.

## Requirements

| Name                                                                         | Version         |
| ---------------------------------------------------------------------------- | --------------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform)    | >= 1.0, < 1.6.0 |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.13         |

## Providers

| Name                                                                   | Version |
| ---------------------------------------------------------------------- | ------- |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.13 |

## Modules

No modules.

## Resources

| Name                                                                                                                                              | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [kubernetes_service.bitbucket_runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service)                 | resource |
| [kubernetes_service_account.bitbucket_runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service_account) | resource |
| [kubernetes_stateful_set.bitbucket_runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set)       | resource |

## Inputs

| Name                                                                                                                                  | Description                                                                                          | Type                                                                                                                                                                                                                                                                                                                                     | Default                                                                                                                                               | Required |
| ------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------- | :------: |
| <a name="input_bitbucket_runners"></a> [bitbucket\_runners](#input\_bitbucket\_runners)                                               | Map of Bitbucket runner definitions                                                                  | <pre>map(object({<br>    resources = optional(object({<br>      limits = optional(object({<br>        cpu    = optional(string)<br>        memory = optional(string)<br>      }))<br>      requests = optional(object({<br>        cpu    = optional(string)<br>        memory = optional(string)<br>      }))<br>    }))<br>  }))</pre> | n/a                                                                                                                                                   |   yes    |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace)                                                           | Kubernetes namespace where to deploy the runners to                                                  | `string`                                                                                                                                                                                                                                                                                                                                 | n/a                                                                                                                                                   |   yes    |
| <a name="input_k8s_labels"></a> [k8s\_labels](#input\_k8s\_labels)                                                                    | Labels to apply to all Kubernetes objects                                                            | `map(string)`                                                                                                                                                                                                                                                                                                                            | `{}`                                                                                                                                                  |    no    |
| <a name="input_k8s_node_selector"></a> [k8s\_node\_selector](#input\_k8s\_node\_selector)                                             | Node selector to apply to the runner StatefulSets                                                    | `map(string)`                                                                                                                                                                                                                                                                                                                            | `null`                                                                                                                                                |    no    |
| <a name="input_k8s_service_account_annotations"></a> [k8s\_service\_account\_annotations](#input\_k8s\_service\_account\_annotations) | Annotations to attach to the ServiceAccount                                                          | `map(string)`                                                                                                                                                                                                                                                                                                                            | `{}`                                                                                                                                                  |    no    |
| <a name="input_k8s_tolerations"></a> [k8s\_tolerations](#input\_k8s\_tolerations)                                                     | Tolerations to apply to the runner StatefulSets                                                      | <pre>list(object({<br>    effect = string<br>    key    = string<br>    value  = string<br>  }))</pre>                                                                                                                                                                                                                                   | `[]`                                                                                                                                                  |    no    |
| <a name="input_pod_default_resources"></a> [pod\_default\_resources](#input\_pod\_default\_resources)                                 | Default resources that will be applied to all runner Pods, unless overriden in the runner definition | <pre>object({<br>    limits = optional(object({<br>      cpu    = optional(string)<br>      memory = optional(string)<br>    }))<br>    requests = optional(object({<br>      cpu    = optional(string)<br>      memory = optional(string)<br>    }))<br>  })</pre>                                                                      | <pre>{<br>  "limits": {<br>    "cpu": null,<br>    "memory": "4G"<br>  },<br>  "requests": {<br>    "cpu": 1,<br>    "memory": "1G"<br>  }<br>}</pre> |    no    |

## Outputs

| Name                                                                                                                                    | Description |
| --------------------------------------------------------------------------------------------------------------------------------------- | ----------- |
| <a name="output_kubernetes_service_account_name"></a> [kubernetes\_service\_account\_name](#output\_kubernetes\_service\_account\_name) | n/a         |
