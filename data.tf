# gets the account_id and region to build resource arns for the iam policy
data "aws_caller_identity" "current" {}
data "aws_region" "current" {}
