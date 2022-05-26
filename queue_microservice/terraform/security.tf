# Roles
resource "aws_iam_role" "sf_role" {
  name = var.role_names[0]

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "states.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

resource "aws_iam_role" "lambda_role" {
  name = var.role_names[1]

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "lambda.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
}

# Policies
resource "aws_iam_policy" "sf_sqs_send" {
  name        = var.sf_policy_name[0]
  description = "Allows AWS Step Functions to send messages to SQS queues on your behalf"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "sqs:SendMessage",
        ]
        Effect   = "Allow"
        Resource = "arn:aws:sqs:${data.aws_region.aws_user_region.name}:${data.aws_caller_identity.aws_user_info.account_id}:${var.queue_name}"
      },
    ]
  })
}

resource "aws_iam_policy" "sf_xray_access" {
  name        = var.sf_policy_name[1]
  description = "Allow AWS Step Functions to call X-Ray daemon on your behalf"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "xray:PutTraceSegments",
          "xray:PutTelemetryRecords",
          "xray:GetSamplingRules",
          "xray:GetSamplingTargets"
        ]
        Effect   = "Allow"
        Resource = "*"
      },
    ]
  })
}

# Attach policies to roles
resource "aws_iam_policy_attachment" "attach_sqs_to_sf_role" {
  name       = "${var.sf_policy_name[0]}-sf_sqs_policy"
  roles      = [aws_iam_role.sf_role.name]
  policy_arn = aws_iam_policy.sf_sqs_send.arn
}

resource "aws_iam_policy_attachment" "attach_xray_to_sf_role" {
  name       = "${var.sf_policy_name[1]}-sf_xray_policy"
  roles      = [aws_iam_role.sf_role.name]
  policy_arn = aws_iam_policy.sf_xray_access.arn
}

resource "aws_iam_policy_attachment" "attach_sf_to_lambda_role" {
  name       = "${var.role_names[1]}-lambda_sf_policy"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = data.aws_iam_policy.AWSStepFunctionsFullAccess.arn
}

resource "aws_iam_policy_attachment" "attach_sqs_to_lambda_role" {
  name       = "${var.role_names[1]}-lambda_sqs_policy"
  roles      = [aws_iam_role.lambda_role.name]
  policy_arn = data.aws_iam_policy.AmazonSQSFullAccess.arn
}

