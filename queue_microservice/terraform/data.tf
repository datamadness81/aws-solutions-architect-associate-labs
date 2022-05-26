data "aws_caller_identity" "aws_user_info" {}

data "aws_region" "aws_user_region" {}

data "aws_iam_policy" "AmazonSQSFullAccess" {
  arn = "arn:aws:iam::aws:policy/AmazonSQSFullAccess"
}

data "aws_iam_policy" "AWSStepFunctionsFullAccess" {
  arn = "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess"
}
