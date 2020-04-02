variable snapshot_schedule {
  default = "cron(0/5 * * * ? *)"
  description = "The cron schedule for creating ebs volume snapshots."

}

resource "aws_cloudwatch_event_rule" "nl-schedule-snapshots-event-rule" {
  name = "nl-eventrule-backups"
  description = "Create EBS volume snapshots once a day starting at midnight."

  schedule_expression = var.snapshot_schedule
}

resource "aws_cloudwatch_event_target" "nl-schedule-snapshots-event-target" {
  rule      = aws_cloudwatch_event_rule.nl-schedule-snapshots-event-rule.name
  target_id = "nl-snapshot-backups"
  arn       = aws_lambda_function.nl-lecp_backups_lambda.arn
}

