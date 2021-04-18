output "ecs_tagger_eventbridge_rule_arn" {
    value = module.my_ecs_task_tagger.eventbridge_rule.arn
}

output "ecs_tagger_iam_role_arn" {
    value = module.my_ecs_task_tagger.iam_role.arn
}

output "ecs_tagger_lambda_function_arn" {
    value = module.my_ecs_task_tagger.lambda_function.arn
}

output "ecs_tagger_log_group_name" {
    value = module.my_ecs_task_tagger.log_group.name
}
