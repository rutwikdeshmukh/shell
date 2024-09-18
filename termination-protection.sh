#!/bin/bash

# Read the StackNames from stack-names.json
StackNames=$(jq -r '.StackNames[]' stack-names.json)
n=0
# Loop through each name and run the AWS command
for StackName in $StackNames; do
  n=$((n+1))
  termination_protection_status=$(aws cloudformation describe-stacks --stack-name "$StackName" | jq -r '.Stacks[0].EnableTerminationProtection')
  echo "$n. Stack Name: $StackName"
  echo "Current Termination Protection Status: $termination_protection_status"
  aws cloudformation update-termination-protection --stack-name "$StackName" --enable-termination-protection > /dev/null
  updated_termination_protection_status=$(aws cloudformation describe-stacks --stack-name "$StackName" | jq -r '.Stacks[0].EnableTerminationProtection')
  echo "Updated Termination Protection Status: $updated_termination_protection_status"
done