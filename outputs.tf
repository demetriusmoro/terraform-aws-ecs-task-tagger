# variables used to build names using the cluster name
output "iam_role" {
  value = aws_iam_role.ecs_task_tagger_lambda_role
  description = "IAM role created to execute the lambda function."
}

output "lambda_function" {
  value = aws_lambda_function.ecs_task_tagger_lambda
  description = "Lambda function triggered when an ecs task is launched to updates its tags."
}

output "log_group" {
  value = aws_cloudwatch_log_group.ecs_task_tagger_lambda_log_group
  description = "Log group created to record the lambda function log streams."
}

output "eventbridge_rule" {
  value = aws_cloudwatch_event_rule.ecs_task_tagger_lambda_rule
  description = "EventBridge rule set up to invoke the lambda function whenever an ecs task is launched."
}
