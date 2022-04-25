#----------------------------------------------------
#                   VARIABLES
#----------------------------------------------------

variable "region" {
  description = "AWS region by default"
  default     = "us-east-1"
}

variable "resource_name" {
  description = "Name of the resources created to finding them more easily in the AWS Console"
  default     = "serveless-basic-wf"
}

variable "state_machine_name" {
  description = "Name of the step functions state machine"
  type = string
  default = "CallCenterStateMachine"
}

variable "lambdas" {
  description = "lambdas dict to iterate in with the terraform's lambda function"
  type        = map(string)
  default = {
    "OpenCaseFunction"     = "01_OpenCaseFunction.zip",
    "AssignCaseFunction"   = "02_AssignCaseFunction.zip",
    "WorkOnCaseFunction"   = "03_WorkOnCaseFunction.zip",
    "EscalateCaseFunction" = "04_EscalateCaseFunction.zip"
    "CloseCaseFunction"    = "05_CloseCaseFunction.zip",
  }
}

