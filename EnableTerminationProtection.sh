#!/bin/bash


# Get the stack names using AWS Command to an JSON File
aws cloudformation list-stacks --query "StackSummaries[?StackStatus=='UPDATE_COMPLETE' || StackStatus=='CREATE_COMPLETE'].StackName" --output json | jq '{StackNames: .}' > stack-names.json

# Read the StackNames from stack-names.json
StackNames=$(jq -r '.StackNames[]' stack-names.json)

n=0

# Loop through each name and run the AWS command
for StackName in $StackNames; do
  n=$((n+1))
  aws cloudformation update-termination-protection --stack-name "$StackName" --enable-termination-protection > /dev/null
  echo "$n. $StackName: Termination Protection ENABLED"
done
