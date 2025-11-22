
resource "aws_cloudwatch_metric_alarm" "high_cpu" {
    alarm_name = "rds-${var.db_identifier}-high-cpu"
    alarm_description = "Triggers when the RDS CPU utilization rises above 80%"

    evaluation_periods = 3
    period = 60 # one minute

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

resource "aws_cloudwatch_metric_alarm" "high_swap" {
    alarm_name = "rds-${var.db_identifier}-high-swap"
    alarm_description = "Triggers when the RDS swap utilization rises above 256MB"

    evaluation_periods = 3
    period = 60 # one minute

    namespace = "AWS/RDS"
    metric_name = "SwapUsage"
    statistic = "Average"
    comparison_operator = "GreaterThanThreshold"
    threshold = 268435456

    dimensions = {
        DBInstanceIdentifier = var.db_identifier
    }

    treat_missing_data = "missing"

    alarm_actions = [aws_sns_topic.alerts.arn]
    ok_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "disk_queue" {
    alarm_name = "rds-${var.db_identifier}-long-disk-queue"
    alarm_description = "Triggers when there are more than 64 disk operations queued (high contention)"

    evaluation_periods = 3
    period = 60 # one minute

    namespace = "AWS/RDS"
    metric_name = "DiskQueueDepth"
    statistic = "Average"
    comparison_operator = "GreaterThanThreshold"
    threshold = 64

    dimensions = {
        DBInstanceIdentifier = var.db_identifier
    }

    treat_missing_data = "notBreaching"

    alarm_actions = [aws_sns_topic.alerts.arn]
    ok_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_memory" {
    alarm_name = "rds-${var.db_identifier}-low-memory"
    alarm_description = "Triggers when available memory is under 64MB"

    evaluation_periods = 3
    period = 60 # one minute

    namespace = "AWS/RDS"
    metric_name = "FreeableMemory"
    statistic = "Average"
    comparison_operator = "LowerThanThreshold"
    threshold = 67108864

    dimensions = {
        DBInstanceIdentifier = var.db_identifier
    }

    treat_missing_data = "notBreaching"

    alarm_actions = [aws_sns_topic.alerts.arn]
    ok_actions = [aws_sns_topic.alerts.arn]
}

resource "aws_cloudwatch_metric_alarm" "low_disk" {
    alarm_name = "rds-${var.db_identifier}-low-disk"
    alarm_description = "Triggers when available disk is under 2GB"

    evaluation_periods = 3
    period = 60 # one minute

    namespace = "AWS/RDS"
    metric_name = "FreeStorageSpace"
    statistic = "Average"
    comparison_operator = "LowerThanThreshold"
    threshold = 2147483648

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