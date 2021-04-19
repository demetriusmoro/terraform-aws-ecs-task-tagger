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
