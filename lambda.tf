# function to copy tags from a task definition to a launching task
resource "aws_lambda_function" "ecs_task_tagger_lambda" {
  function_name    = local.lambda_name
  filename         = "${path.module}/assets/lambda_package.zip"
  source_code_hash = filebase64sha256("${path.module}/assets/lambda_package.zip")
  role             = aws_iam_role.ecs_task_tagger_lambda_role.arn
  handler          = "start.lambda_handler"
  runtime          = "python3.8"
  memory_size      = 128
  timeout          = 10

  tags = merge(var.tags, {
    Name = local.lambda_name
  })
}

# lambda function logs on cloudwatch
resource "aws_cloudwatch_log_group" "ecs_task_tagger_lambda_log_group" {
  name              = local.log_group_name
  retention_in_days = 7

  tags = merge(var.tags, {
    Name = local.log_group_name
  })
}
