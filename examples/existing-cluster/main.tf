module "my_ecs_task_tagger" {
  source       = "demetriusmoro/ecs-task-tagger/aws"
  version      = "0.1.0"
  cluster_name = "my-existing-cluster-name"
}
