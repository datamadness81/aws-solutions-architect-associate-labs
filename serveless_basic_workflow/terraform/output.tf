#----------------------------------------------------
#                   OUTPUTS
#----------------------------------------------------

output "lambda_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = values(aws_lambda_function.lambda_function)[*].arn
}

output "step_function_arn" {
  description = "The ARN of the Lambda Function"
  value       = aws_sfn_state_machine.sfn_state_machine.arn
}

output "lambda_functions" {
  description = "Functions as a string map"
  value       = keys(var.lambdas)
}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "caller_arn" {
  value = data.aws_caller_identity.current.arn
}

output "caller_user" {
  value = data.aws_caller_identity.current.user_id
}