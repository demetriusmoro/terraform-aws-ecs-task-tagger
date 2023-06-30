# Existing cluster

This is how you use this module to setup a task tagger for an existing ECS Cluster, you will need only the cluster name.

```hcl
module "my_ecs_task_tagger" {
  source       = "demetriusmoro/ecs-task-tagger/aws"
  version      = "0.1.0"
  cluster_name = "my-existing-cluster-name"
}
```
