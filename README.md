<!-- markdownlint-disable MD033 -->

# Terraform Bitbucket Runners

This module sets up a set of Bitbucket runners on a Kubernetes cluster. It accepts a list of runner configurations and deploys a `Service` and a `StatefulSet` for each of them.

## Requirements

| Name                                                                         | Version |
| ---------------------------------------------------------------------------- | ------- |
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform)    | ~> 1.0  |
| <a name="requirement_kubernetes"></a> [kubernetes](#requirement\_kubernetes) | ~> 2.13 |

## Providers

| Name                                                                   | Version |
| ---------------------------------------------------------------------- | ------- |
| <a name="provider_kubernetes"></a> [kubernetes](#provider\_kubernetes) | ~> 2.13 |

## Modules

No modules.

## Resources

| Name                                                                                                                                        | Type     |
| ------------------------------------------------------------------------------------------------------------------------------------------- | -------- |
| [kubernetes_service.bitbucket_runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/service)           | resource |
| [kubernetes_stateful_set.bitbucket_runner](https://registry.terraform.io/providers/hashicorp/kubernetes/latest/docs/resources/stateful_set) | resource |

## Inputs

| Name                                                                                      | Description                                         | Type                                                                                                   | Default | Required |
| ----------------------------------------------------------------------------------------- | --------------------------------------------------- | ------------------------------------------------------------------------------------------------------ | ------- | :------: |
| <a name="input_bitbucket_runners"></a> [bitbucket\_runners](#input\_bitbucket\_runners)   | Map of Bitbucket runner definitions                 | `map(any)`                                                                                             | n/a     |   yes    |
| <a name="input_environment"></a> [environment](#input\_environment)                       | n/a                                                 | `string`                                                                                               | n/a     |   yes    |
| <a name="input_k8s_namespace"></a> [k8s\_namespace](#input\_k8s\_namespace)               | Kubernetes namespace where to deploy the runners to | `string`                                                                                               | n/a     |   yes    |
| <a name="input_k8s_node_selector"></a> [k8s\_node\_selector](#input\_k8s\_node\_selector) | Node selector to apply to the runner StatefulSets   | `map(string)`                                                                                          | `null`  |    no    |
| <a name="input_k8s_tolerations"></a> [k8s\_tolerations](#input\_k8s\_tolerations)         | Tolerations to apply to the runner StatefulSets     | <pre>list(object({<br>    effect = string<br>    key    = string<br>    value  = string<br>  }))</pre> | `[]`    |    no    |

## Outputs

No outputs.
