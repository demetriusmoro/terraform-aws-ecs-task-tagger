# creates roles to be used by the lambda function when executing
resource "aws_iam_role" "ecs_task_tagger_lambda_role" {
  name = local.iam_role_name
  path = "/serviceRole/"

  assume_role_policy = data.aws_iam_policy_document.ecs_task_tagger_lambda_role_trustpolicy.json

  tags = merge(var.tags, {
    Name = local.iam_role_name
  })
}

# assume role policy to allow its use by aws lambda service when calling the function
data "aws_iam_policy_document" "ecs_task_tagger_lambda_role_trustpolicy" {
  statement {
    actions = [
      "sts:AssumeRole"
    ]
    principals {
      type = "Service"
      identifiers = [
        "lambda.amazonaws.com"
      ]
    }
  }
}

# lambda function permissions to query ecs data, update tasks and log execution on cloudwatch
resource "aws_iam_policy" "ecs_task_tagger_lambda_policy" {
  name   = local.iam_policy_name
  path   = "/serviceRole/"
  policy = data.aws_iam_policy_document.ecs_task_tagger_lambda_policy_doc.json
}

# policy document used by the above policy
data "aws_iam_policy_document" "ecs_task_tagger_lambda_policy_doc" {
  statement {
    actions = [
      "logs:CreateLogGroup"
    ]
    resources = [
      format(
        "arn:aws:logs:%s:%s:*",
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id
      )
    ]
  }
  statement {
    actions = [
      "logs:CreateLogStream",
      "logs:PutLogEvents"
    ]
    resources = [
      format(
        "arn:aws:logs:%s:%s:log-group:%s:*",
        data.aws_region.current.name,
        data.aws_caller_identity.current.account_id,
        local.log_group_name
      )
    ]
  }
  statement {
    actions = [
      "ecs:DescribeClusters",
      "ecs:DescribeTaskDefinition",
      "ecs:DescribeTasks",
      "ecs:TagResource"
    ]
    resources = ["*"]
  }
}

# role/policy attachment for the lambda function execution role
resource "aws_iam_role_policy_attachment" "ecs_task_tagger_role_policy_attach" {
  role       = aws_iam_role.ecs_task_tagger_lambda_role.name
  policy_arn = aws_iam_policy.ecs_task_tagger_lambda_policy.arn
}
