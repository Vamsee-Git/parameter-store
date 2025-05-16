variable "email" {}

resource "aws_sns_topic" "param_update_topic" {
  name = "parameter-update-topic"
}

resource "aws_sns_topic_subscription" "email_sub" {
  topic_arn = aws_sns_topic.param_update_topic.arn
  protocol  = "email"
  endpoint  = var.email
}

output "sns_topic_arn" {
  value = aws_sns_topic.param_update_topic.arn
}
