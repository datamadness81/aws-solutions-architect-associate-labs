variable "resource_name" {
  description = "Name of the resources created to finding them more easily in the AWS Console"
  default     = "queue_based_microservices"
}

variable "state_machine_name" {
  description = "Name of the step functions state machine"
  type        = string
  default     = "InventoryStateMachine"
}

variable "queue_name" {
  description = "Name of the queue"
  type        = string
  default     = "Orders"
}

variable "role_names" {
  description = "assigned role names"
  type        = list(string)
  default = [
    "inventory-state-machine-role",
    "inventory-lambda-role"
  ]
}

variable "sf_policy_name" {
  description = "Custom policies names"
  type        = list(string)
  default = [
    "SQSSendMessageScopedAccessPolicy",
    "XRayAccessPolicy"
  ]
}

variable "lambda_name" {
  description = "Lambda name"
  type        = string
  default     = "Inventory"
}

variable "account_id" {
  description = "AWS Account ID"
  type        = string
  default     = "700050813749"
}
