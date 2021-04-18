# creates a rule to trigger when ecs tasks reach to PENDING state during launch
resource "aws_cloudwatch_event_rule" "ecs_task_tagger_lambda_rule" {
  name       = local.event_rule_name
  is_enabled = true
  event_pattern = templatefile("${path.module}/assets/eventbridge_rule_event_pattern.json", {
    cluster_arn = data.aws_ecs_cluster.ecs_cluster.arn
  })

  tags = merge(var.tags, {
    Name = local.event_rule_name
  })
}

# register the needed lambda function as the rule target
resource "aws_cloudwatch_event_target" "ecs_task_tagger_lambda_rule_target" {
  target_id = format("invoke-%s", aws_lambda_function.ecs_task_tagger_lambda.function_name)
  rule      = aws_cloudwatch_event_rule.ecs_task_tagger_lambda_rule.name
  arn       = aws_lambda_function.ecs_task_tagger_lambda.arn
}

# gives eventbrigde permission to invoke the lambda function
resource "aws_lambda_permission" "ecs_task_tagger_lambda_permission" {
  statement_id  = "AllowExecutionFromCloudWatch"
  action        = "lambda:InvokeFunction"
  function_name = aws_lambda_function.ecs_task_tagger_lambda.function_name
  principal     = "events.amazonaws.com"
  source_arn    = aws_cloudwatch_event_rule.ecs_task_tagger_lambda_rule.arn
}
