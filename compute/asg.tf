resource "aws_appautoscaling_target" "ecs" {
  max_capacity       = var.max_capacity
  min_capacity       = var.min_capacity
  resource_id        = "service/${aws_ecs_cluster.main.name}/${aws_ecs_service.web_service.name}"
  scalable_dimension = "ecs:service:DesiredCount"
  service_namespace  = "ecs"
}

#Scale out when CPU > 70% using TargetTracking
resource "aws_appautoscaling_policy" "scale_out" {
  name               = "${var.BeatStar}-scale-out"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  policy_type        = "TargetTrackingScaling"

  target_tracking_scaling_policy_configuration {
    target_value       = 70.0
    predefined_metric_specification {
      predefined_metric_type = "ECSServiceAverageCPUUtilization"
    }
    scale_in_cooldown  = 60
    scale_out_cooldown = 60
  }
}

#Scale in when CPU < 40% using StepScaling
resource "aws_appautoscaling_policy" "scale_in" {
  name               = "${var.BeatStar}-scale-in"
  service_namespace  = "ecs"
  resource_id        = aws_appautoscaling_target.ecs.resource_id
  scalable_dimension = aws_appautoscaling_target.ecs.scalable_dimension
  policy_type        = "StepScaling"

  step_scaling_policy_configuration {
    adjustment_type = "ChangeInCapacity"

    step_adjustment {
      scaling_adjustment = -1
      metric_interval_upper_bound = 50
    }
    step_adjustment {
  metric_interval_lower_bound = 50
  scaling_adjustment = -2
}

    cooldown = 60
    metric_aggregation_type = "Average"
  }
}
