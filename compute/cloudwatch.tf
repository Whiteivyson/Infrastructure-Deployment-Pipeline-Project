resource "aws_cloudwatch_dashboard" "ecs_dashboard" {
  dashboard_name = "${var.BeatStar}-ecs-dashboard"

  dashboard_body = jsonencode({
    widgets = [
      {
        type   = "metric"
        x      = 0
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ECS/ContainerInsights", "CpuUtilization", "ServiceName", aws_ecs_service.web_service.name, "ClusterName", aws_ecs_cluster.main.name]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "ECS Service CPU Utilization"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 0
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["ECS/ContainerInsights", "MemoryUtilization", "ServiceName", aws_ecs_service.web_service.name, "ClusterName", aws_ecs_cluster.main.name]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "ECS Service Memory Utilization"
        }
      },
      {
        type   = "metric"
        x      = 0
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "RequestCount", "LoadBalancer", aws_lb.web_alb.arn_suffix]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "ALB Request Count"
        }
      },
      {
        type   = "metric"
        x      = 12
        y      = 6
        width  = 12
        height = 6
        properties = {
          metrics = [
            ["AWS/ApplicationELB", "HTTPCode_Target_5XX_Count", "LoadBalancer", aws_lb.web_alb.arn_suffix]
          ],
          view    = "timeSeries",
          stacked = false,
          region  = var.aws_region,
          title   = "ALB 5XX Errors"
        }
      }
    ]
  })
}
