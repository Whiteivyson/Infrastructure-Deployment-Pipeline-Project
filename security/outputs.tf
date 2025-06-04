output "ecs_task_execution_role_arn" {
  value = aws_iam_role.ecs_task_execution.arn
}

output "ecs_security_group_id" {
  value = aws_security_group.ecs_sg.id

}

output "alb_security_group_id" {
  value = aws_security_group.alb_sg.id

}

output "jenkins_security_group_id" {
  value = aws_security_group.jenkins_sg.id

}

# output "codedeploy_role_arn" {
#   value = aws_iam_role.codedeploy-role.arn

# }