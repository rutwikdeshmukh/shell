#!/bin/bash

# Prompt user for input
echo "Enter the GIT REPO URL: "
read REPO_URL

# Clone the repository
git clone $REPO_URL

# Change into the cloned repository directory
REPO=$(basename "$REPO_URL")
repo_name=${REPO%.*}
echo "$repo_name"
cd $repo_name

# Checkout the main branch
git checkout main

# Create a new branch named int out of main and push it to origin
git checkout -b int
git push -u origin int

# Create a new branch named dev out of int and push it to origin
git checkout -b dev
git push -u origin dev

# Create a new branch named aws out of dev and push it to origin
git checkout -b aws
git push -u origin aws

# Copy Buildspec from huub88
# cp ../../callback-hub88api_php/buildspec.yml .

# Check out of the Cloned Directory
cd ..