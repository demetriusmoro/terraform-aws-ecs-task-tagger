# variables used to build names using the cluster name
locals {
  iam_role_name  = "${var.cluster_name}-task-tagger-role"
  iam_policy_name = "${var.cluster_name}-task-tagger-policy"
  lambda_name     = "${var.cluster_name}-task-tagger"
  log_group_name  = "/aws/lambda/${var.cluster_name}-task-tagger"
  event_rule_name = "${var.cluster_name}-task-tagger-rule"
}
