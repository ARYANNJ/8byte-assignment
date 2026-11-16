output "log_group_name" {
  description = "CloudWatch log group used by the ECS service"
  value       = var.log_group_name
}

output "log_group_name" {
  value = aws_cloudwatch_log_group.this.name
}

output "task_role_arn" {
  value = aws_iam_role.task.arn
}

output "target_group_arn" {
  value = one(aws_lb_target_group.this[*].arn)
}

output "target_group_arn_suffix" {
  value = one(aws_lb_target_group.this[*].arn_suffix)
}