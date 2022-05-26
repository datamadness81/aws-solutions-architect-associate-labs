# Serveless Messaging
resource "aws_sqs_queue" "orders_queue" {
  name                       = var.queue_name
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
        "AWS": [
          "${data.aws_caller_identity.aws_user_info.arn}",
          "arn:aws:iam::${data.aws_caller_identity.aws_user_info.account_id}:root"
        ]
      },
      "Action": [
        "SQS:*"
      ],
      "Resource": "arn:aws:sqs:${data.aws_region.aws_user_region.name}:${data.aws_caller_identity.aws_user_info.account_id}:${var.queue_name}"
    }
  ]
}
EOT
}

# Lambda Functions
resource "aws_lambda_function" "lambda_function" {
  filename      = "../Inventory.zip"
  function_name = var.lambda_name
  role          = aws_iam_role.lambda_role.arn
  handler       = "index.handler"
  runtime       = "nodejs16.x"
}

resource "aws_lambda_event_source_mapping" "lambda_trigger" {
  event_source_arn = aws_sqs_queue.orders_queue.arn
  function_name    = aws_lambda_function.lambda_function.arn
}

# Step Functions
resource "aws_sfn_state_machine" "sf_state_machine" {
  name     = var.state_machine_name
  role_arn = aws_iam_role.sf_role.arn
  type     = "STANDARD"

  definition = <<EOF
{
  "Comment": "An example of the Amazon States Language for starting a callback task.",
  "StartAt": "Check Inventory",
  "States": {
    "Check Inventory": {
      "Type": "Task",
      "Resource": "arn:aws:states:::sqs:sendMessage.waitForTaskToken",
      "Parameters": {
        "QueueUrl": "${aws_sqs_queue.orders_queue.url}",
        "MessageBody": {
          "MessageTitle": "Callback Task started by Step Functions",
          "TaskToken.$": "$$.Task.Token"
        }
      },
      "Next": "Notify Success",
      "Catch": [
      {
        "ErrorEquals": [ "States.ALL" ],
        "Next": "Notify Failure"
      }
      ]
    },
    "Notify Success": {
      "Type": "Pass",
      "Result": "Callback Task started by Step Functions succeeded",
      "End": true
    },
    "Notify Failure": {
      "Type": "Pass",
      "Result": "Callback Task started by Step Functions failed",
      "End": true
    }
  }
}
EOF

}
