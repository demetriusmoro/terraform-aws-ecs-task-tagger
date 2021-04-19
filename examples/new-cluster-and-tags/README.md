# New cluster and tags

If you are creating a new cluster within the same Terraform project, this is how you can use a reference to your newly created cluster.

Also, in this example you will add tags to the reasources created by the module, enabling a better resource tracking and management.

```hcl
resource "aws_ecs_cluster" "my_new_ecs_cluster" {
  name = "my-ecs-cluster"
}

module "my_ecs_task_tagger" {
  source       = "demetriusmoro/ecs-task-tagger/aws"
  version      = "0.0.4"
  cluster_name = aws_ecs_cluster.my_new_ecs_cluster.name
  tags = {
    Project    = "ThisIsANewProject"
    CostCenter = "123"
  }
}

```
