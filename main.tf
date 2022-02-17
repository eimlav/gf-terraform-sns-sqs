terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
}

// Providers

provider "aws" {
  region                      = var.aws_region
  access_key                  = var.aws_access_key
  secret_key                  = var.aws_secret_key
  skip_credentials_validation = true
  skip_metadata_api_check     = true
  skip_requesting_account_id  = true

  endpoints {
    sns  = "http://localhost:4566"
    sqs  = "http://localhost:4566"
  }

  default_tags {
   tags = {
     Environment = var.env
   }
 }
}

// SNS resources

resource "aws_sns_topic" "glofox_billing_invoices" {
    name = "glofox_billing_invoices"
}

// SQS resources

resource "aws_sqs_queue" "glofox_billing_memberships" {
    name = "glofox_billing_memberships"
}

// Setup access policies for SNS

resource "aws_sqs_queue_policy" "glofox_billing_memberships" {
  queue_url = aws_sqs_queue.glofox_billing_memberships.id

  policy = <<POLICY
{
  "Version": "2021-10-26",
  "Id": "sqspolicy",
  "Statement": [
    {
      "Sid": "First",
      "Effect": "Allow",
      "Principal": {
          "Service": "sns.amazonaws.com"
      },
      "Action": "sqs:SendMessage",
      "Resource": "${aws_sqs_queue.glofox_billing_memberships.arn}",
      "Condition": {
        "ArnEquals": {
          "aws:SourceArn": "${aws_sns_topic.glofox_billing_invoices.arn}"
        }
      }
    }
  ]
}
POLICY
}

// Setup subscriptions

resource "aws_sns_topic_subscription" "glofox_billing_memberships_target" {
  topic_arn = aws_sns_topic.glofox_billing_invoices.arn
  protocol  = "sqs"
  endpoint  = aws_sqs_queue.glofox_billing_memberships.arn
}

// TODO: Setup IAM policies