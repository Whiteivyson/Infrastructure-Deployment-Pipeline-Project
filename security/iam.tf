#IAM roles and policies for ECS tasks and execution using least privilege principles
# ECS Task Execution Role
resource "aws_iam_role" "ecs_task_execution" {
  name = "${var.BeatStar}-ecs-task-execution-role"
  
  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Action = "sts:AssumeRole",
        Effect = "Allow",
        Principal = {
          Service = "ecs-tasks.amazonaws.com"
        }
      }
    ]
  })

  tags = {
    Name = "${var.BeatStar}-ecs-execution-role"
  }
}

resource "aws_iam_policy_attachment" "ecs_task_execution_policy" {
  name       = "${var.BeatStar}-ecs-task-execution-policy-attach"
  roles      = [aws_iam_role.ecs_task_execution.name]
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}
