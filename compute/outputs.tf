output "ecs_cluster_id" {
  value = aws_ecs_cluster.main.id
}

output "ecs_service_name" {
  value = aws_ecs_service.web_service.name
}

output "target_group_arn" {
  value = aws_lb_target_group.web_tg.arn

}

output "listener_arn" {
  value = aws_lb_listener.http.arn

}

output "alb_dns_name" {
  value = aws_lb.web_alb.dns_name
}

output "aws_s3_bucket_name" {
  value = aws_s3_bucket.beatstar-tf-backend-1999.id

}

output "ecr_repo_url" {
  description = "The URL of the ECR repository"
  value       = aws_ecr_repository.app_repo.repository_url
}
