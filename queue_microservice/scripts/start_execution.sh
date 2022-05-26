#!/bin/bash -
#===============================================================================
#
#          FILE: start_execution.sh
#
#         USAGE: ./start_execution.sh
#
#   DESCRIPTION: Start a step functions workflow
#
#  REQUIREMENTS: AWS CLI V2
#       CREATED: 26/05/22 10:55:10
#      REVISION:  ---
#===============================================================================

set -o nounset                                  # Treat unset variables as an error

# Variables needed for the state machine start-execution
SM_ARN=$(aws stepfunctions \
    list-state-machines \
    --query 'stateMachines[*].stateMachineArn' \
    --output text)

# Starting the state machine execution
aws stepfunctions start-execution \
    --state-machine-arn $SM_ARN \
    --input '"input": "{\"execution\" : \"test_03\"}"' 
