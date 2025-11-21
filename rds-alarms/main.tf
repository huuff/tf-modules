
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
    alarm_name = "${var.db_identifier}-high-cpu"
    alarm_description = "Triggers when the RDS CPU utilization rises above 80%"

    evaluation_periods = 3
    period = 60

    namespace = "AWS/RDS"
    metric_name = "CPUUtilization"
    statistic = "Average"
    comparison_operator = "GreaterThanThreshold"
    threshold = 80
    unit = "Percent"

    dimensions = {
        DBInstanceIdentifier = var.db_identifier
    }

    treat_missing_data = "notBreaching"

    alarm_actions = [aws_sns_topic.alerts.arn]
    ok_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_sns_topic" "alerts" {
    name = "${var.db_identifier}-alerts"
}

resource "aws_sns_topic_subscription" "email_subscription" {
    count = length(var.target_emails)

    topic_arn = aws_sns_topic.alerts.arn
    protocol = "email"
    endpoint = var.target_emails[count.index]
}