#---------------------------------------------------------
#                       SERVERLESS
#---------------------------------------------------------

#---------------------LAMBDA FUNCTIONS----------------------

resource "aws_lambda_function" "lambda_function" {
  for_each      = var.lambdas
  filename      = "../functions/${each.value}"
  function_name = each.key
  role          = aws_iam_role.lambda_basic_execution.arn
  handler       = "index.handler"
  runtime       = "nodejs14.x"

  tags = {
    Name = "${each.key}"
  }
}

#---------------------STEP FUNCTIONS----------------------

resource "aws_sfn_state_machine" "sfn_state_machine" {
  name     = var.state_machine_name
  role_arn = aws_iam_role.step_functions_basic_execution.arn
  type     = "STANDARD"

  definition = <<EOF
{
  "Comment": "A simple AWS Step Functions state machine that automates a call center support session.",
  "StartAt": "Open Case",
  "States": {
    "Open Case": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_function["OpenCaseFunction"].arn}",
      "Next": "Assign Case"
    }, 
    "Assign Case": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_function["AssignCaseFunction"].arn}",
      "Next": "Work on Case"
    },
    "Work on Case": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_function["WorkOnCaseFunction"].arn}",
      "Next": "Is Case Resolved"
    },
    "Is Case Resolved": {
        "Type" : "Choice",
        "Choices": [ 
          {
            "Variable": "$.Status",
            "NumericEquals": 1,
            "Next": "Close Case"
          },
          {
            "Variable": "$.Status",
            "NumericEquals": 0,
            "Next": "Escalate Case"
          }
      ]
    },
     "Close Case": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_function["CloseCaseFunction"].arn}",
      "End": true
    },
    "Escalate Case": {
      "Type": "Task",
      "Resource": "${aws_lambda_function.lambda_function["EscalateCaseFunction"].arn}",
      "Next": "Fail"
    },
    "Fail": {
      "Type": "Fail",
      "Cause": "Engage Tier 2 Support."    }
  }
}
EOF

  tags = {
    Module = "Basic_StepFunctions"
  }
}
