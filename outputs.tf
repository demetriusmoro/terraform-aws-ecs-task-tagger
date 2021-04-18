# variables used to build names using the cluster name
output "iam_role" {
  value = aws_iam_role.ecs_task_tagger_lambda_role
}

output "lambda_function" {
  value = aws_lambda_function.ecs_task_tagger_lambda
}

output "log_group" {
  value = aws_cloudwatch_log_group.ecs_task_tagger_lambda_log_group
}

output "eventbridge_rule" {
  value = aws_cloudwatch_event_rule.ecs_task_tagger_lambda_rule
}
