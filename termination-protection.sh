#!/bin/bash

# Read the StackNames from stack-names.json
StackNames=$(jq -r '.StackNames[]' stack-names.json)
n=0

# Ask user if they want to delete the stacks
read -p "Do you want to delete the stacks mentioned in the JSON file? (yes/no): " delete_stacks

# Ask user if they want to enable or disable termination protection
read -p "Do you want to enable or disable the termination protection for the stacks mentioned in the JSON file? (enable/disable): " termination_protection_action

# Loop through each name and run the AWS command
for StackName in $StackNames; do
  n=$((n+1))
  termination_protection_status=$(aws cloudformation describe-stacks --stack-name "$StackName" | jq -r '.Stacks[0].EnableTerminationProtection')
  echo "$n. Stack Name: $StackName"
  echo "Current Termination Protection Status: $termination_protection_status"

  if [ "enable" == "$termination_protection_action" ]; then
    aws cloudformation update-termination-protection --stack-name "$StackName" --enable-termination-protection > /dev/null
  else
    aws cloudformation update-termination-protection --stack-name "$StackName" --no-enable-termination-protection > /dev/null
  fi

  updated_termination_protection_status=$(aws cloudformation describe-stacks --stack-name "$StackName" | jq -r '.Stacks[0].EnableTerminationProtection')
  echo "Updated Termination Protection Status: $updated_termination_protection_status"

  if [ "yes" == "$delete_stacks" ] && [ "false" == "$updated_termination_protection_status" ] ; then
    aws cloudformation delete-stack --stack-name "$StackName"
    echo "Stack $StackName has been deleted."
  else
    echo "Stacks cannot be deleted as the Termination Protection is ENABLED"
  fi
done
