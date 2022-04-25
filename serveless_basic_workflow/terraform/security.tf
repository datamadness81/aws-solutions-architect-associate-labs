#----------------------------------------------------
#                   SECURITY
#----------------------------------------------------

#-------------------IAM ROLES------------------------

resource "aws_iam_role" "step_functions_basic_execution" {
  name = "${var.resource_name}-step_functions"

  assume_role_policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Sid" : "",
        "Effect" : "Allow",
        "Principal" : {
          "Service" : "states.amazonaws.com"
        },
        "Action" : "sts:AssumeRole"
      }
    ]
  })
  
  tags = {
    Serverless = "step_functions_role"
  }
}

resource "aws_iam_role" "lambda_basic_execution" {
  name = "${var.resource_name}-lambda"

  assume_role_policy = jsonencode({
    "Version": "2012-10-17",
    "Statement": [
        {
            "Effect": "Allow",
            "Principal": {
                "Service": "lambda.amazonaws.com"
            },
            "Action": "sts:AssumeRole"
        }
    ]
})

  tags = {
    Serverless = "lambda_role"
  }
}

#-------------------POLICIES------------------------

resource "aws_iam_policy_attachment" "attach_step_functions_role" {
    name = "${var.resource_name}-step_functions_policy"
    roles = [aws_iam_role.step_functions_basic_execution.name]
    policy_arn = "${data.aws_iam_policy.AWSLambdaRole.arn}"
}

resource "aws_iam_policy_attachment" "attach_lambda_role" {
    name = "${var.resource_name}-lambda_policy"
    roles = [aws_iam_role.lambda_basic_execution.name]
    policy_arn = "${data.aws_iam_policy.AWSLambdaBasicExecutionRole.arn}"
}