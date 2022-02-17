output "aws_sns_topic-glofox_billing_invoices-arn" {
  description = "ARN for glofox_billing_invoices SNS topic"
  value       = aws_sns_topic.glofox_billing_invoices.arn
}

output "aws_sqs_queue-glofox_billing_memberships-arn" {
  description = "ARN for glofox_billing_memberships SQS queue"
  value       = aws_sqs_queue.glofox_billing_memberships.arn
}