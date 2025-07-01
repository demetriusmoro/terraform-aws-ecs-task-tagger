# AWS ECS Task Tagger Terraform module

[![Maintained by Demetrius Moro](https://img.shields.io/badge/maintained%20by-demetriusmoro-blue)](https://github.com/demetriusmoro) [![Module Version](https://img.shields.io/github/v/tag/demetriusmoro/terraform-aws-ecs-task-tagger?label=version&sort=semver)](https://registry.terraform.io/modules/demetriusmoro/ecs-task-tagger/aws/latest)

This repo contains a [Terraform](https://terraform.io) [Module](https://www.terraform.io/docs/language/modules/index.html) for tagging single ECS-tasks based on their task definition, since it is not supported natively by AWS.

Tasks created by an ECS-service can use the `propagate_tags` property to copy tags to them automatically. Tasks **triggered by ECS-external events** like EventBridge schedules or custom events are created without tags, and that's the **use-case covered by this implementation**.

It creates:

1. A Lambda Function to copy the tags from the task definition to the task being launched *(and the needed IAM role)*.
1. An EventBridge rule to invoke the lambda function. It gets triggered every time a task from the given *ECS Cluster* reaches the `PENDING` status, which occurs before `RUNNING` - read more about [ECS Tasks Lifecycle](https://docs.aws.amazon.com/AmazonECS/latest/developerguide/task-lifecycle-explanation.html).

---

## Usage

The only required value is the `cluster_name`, to identify for which cluster the automation shall be created.

```hcl
module "ecs_task_tagger" {
  source       = "demetriusmoro/ecs-task-tagger/aws"
  version      = "0.1.0"
  cluster_name = "my-existing-ecs-cluster-name"
  # optionally insert tags variable to tag the resources created by this module
}
```
