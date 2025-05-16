variable "sns_topic_arn" {}

resource "aws_cloudwatch_event_rule" "ssm_update_rule" {
  name        = "ssm-parameter-update-rule"
  description = "Triggers on SSM parameter update"
  event_pattern = jsonencode({
    "source": ["aws.ssm"],
    "detail-type": ["Parameter Store Change"],
    "detail": {
      "operation": ["Update"]
    }
  })
}

resource "aws_cloudwatch_event_target" "send_to_sns" {
  rule      = aws_cloudwatch_event_rule.ssm_update_rule.name
  target_id = "SendToSNS"
  arn       = var.sns_topic_arn
}
