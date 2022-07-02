resource "aws_cloudwatch_metric_alarm" "app_scale_up" {
  alarm_name          = format("%s-scale-up-alarm-%s", var.project, var.env)
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "70"

  dimensions = {
    AutoScallingGroupName = aws_autoscaling_group.app_asg.name
  }
  alarm_description = "Scale up by CPU"
  alarm_actions     = [aws_autoscaling_policy.app_scale_up.arn]
}

resource "aws_cloudwatch_metric_alarm" "app_scale_down" {
  alarm_name          = format("%s-scale-down-alarm-%s", var.project, var.env)
  comparison_operator = "LessThanOrEqualToThreshold"
  evaluation_periods  = "2"
  metric_name         = "CPUUtilization"
  namespace           = "AWS/EC2"
  period              = "120"
  statistic           = "Average"
  threshold           = "5"

  dimensions = {
    AutoScallingGroupName = aws_autoscaling_group.app_asg.name
  }
  alarm_description = "Scale down by CPU"
  alarm_actions     = [aws_autoscaling_policy.app_scale_down.arn]
}