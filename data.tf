# gets the account_id and region to build resource arns for the iam policy
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

# gets cluster data to bind it to the eventbridge rule
data "aws_ecs_cluster" "ecs_cluster" {
  cluster_name = var.cluster_name
}
