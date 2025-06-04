variable "BeatStar" {
  description = "Prefix for naming resources"
  type        = string
}

variable "vpc_id" {
  type        = string
  description = "(optional) describe your variable"
}

variable "cpu" {
  type        = string
  description = "CPU units for the task"
  default     = "256"
}

variable "memory" {
  type        = string
  description = "Memory for the task"
  default     = "512"
}

variable "task_execution_role_arn" {
  type        = string
  description = "IAM execution role ARN"
}


variable "container_port" {
  type        = number
  description = "Port exposed by container"
  default     = 80
}

variable "desired_count" {
  type        = number
  default     = 2
}

variable "private_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for ECS tasks"
  
}

variable "public_subnet_ids" {
  type        = list(string)
  description = "List of private subnet IDs for ECS tasks"
  
}
variable "ecs_security_group_id" {
  type        = string
  description = "Security group ID for ECS tasks"
  
}

variable "target_group_arn" {
  type        = string
  description = "ALB target group ARN"
}

variable "listener_arn" {
  type        = string
  description = "ALB listener ARN (used for dependency ordering)"
}

variable "alb_security_group_id" {
  type        = string
  description = "Security group ID for the ALB"
  
}

variable "jenkins_security_group_id" {
  type        = string
  description = "Security group ID for Jenkins"
  
}

variable "min_capacity" {
  type        = number
  description = "Minimum capacity for the ECS service"
  default     = 2
  
}

variable "max_capacity" {
  type        = number
  description = "Maximum capacity for the ECS service"
  default     = 5
  
}

variable "aws_region" {
  description = "AWS region for metrics"
  type        = string
}

variable "aws_s3_bucket_name" {
  description = "S3 bucket name for ALB access logs"
  type        = string
  
}

variable "container_name" {
  description = "The name of the ECS container"
  type        = string
  default     = "web-app"
}

variable "dockerhub_image" {
  description = "The full DockerHub image name (e.g. whiteivyson/my-app:2.1.3)"
  type        = string
  default     = "whiteivyson/my-app:2.1.3"
}

variable "task_definition_arn" {
  description = "ARN of the ECS task definition"
  type        = string
  default     = " "
  
}


