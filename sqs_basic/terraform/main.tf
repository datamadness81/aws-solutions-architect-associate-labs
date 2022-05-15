# Serveless Messaging
resource "aws_sqs_queue" "orders_queue" {
  name                       = "Orders"
  delay_seconds              = 0
  max_message_size           = 262144
  message_retention_seconds  = 345600
  receive_wait_time_seconds  = 0
  visibility_timeout_seconds = 30

  policy = <<EOT
{
  "Version": "2008-10-17",
  "Id": "__default_policy_ID",
  "Statement": [
    {
      "Sid": "__owner_statement",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${data.aws_caller_identity.aws_account_id.account_id}"
      },
      "Action": [
        "SQS:*"
      ],
      "Resource": "arn:aws:sqs:${data.aws_region.default_region.name}:${data.aws_caller_identity.aws_account_id.account_id}:"
    }
  ]
}
EOT

}
