#!/bin/bash

# Set the name of the new repository
read -p "Enter the name of the new repository: " repo_name

# Create the repository directory
mkdir -p "$repo_name"

# Change to the newly created directory
cd "$repo_name"

# Create the repository sub-directory
mkdir -p "docs"
mkdir -p "build"
mkdir -p "scripts"
mkdir -p "pl/pl_scripts"
mkdir -p "pl/ip"
mkdir -p "pl/hdl"
mkdir -p "pl/hls"
mkdir -p "pl/xdc"
mkdir -p "pl/tcl"
mkdir -p "ps/ps_scripts"
mkdir -p "ps/drivers"
mkdir -p "ps/sw_services"
mkdir -p "ps/bsp"
mkdir -p "ps/sw_apps"
mkdir -p "ps/sw_apps_linux"
mkdir -p "sim/libs"
mkdir -p "sim/models"
mkdir -p "sim/sim_scripts"
mkdir -p "sim/testbenches"

# Create a README.md file
echo "# $repo_name" > README.md
echo "" >> README.md

# File to be copied
file_to_copy="README.md" 

# Find all subdirectories recursively
find . -type d | while read -r dir; do
  cp "$file_to_copy" "$dir"
done

# Create a .gitignore file
cat > .gitignore << EOF
*.pyc
__pycache__/
.vscode/
*/.Xil/*
build/
*.ipynb
*.log
*.txt 
EOF

# Initialize a Git repository
git init

# Add all files to the staging area
git add .

# Commit the initial changes
git commit -m "Initial commit"



# Print success message
echo "Repository '$repo_name' created successfully!"

# Optionally open the repository in a code editor (replace with your preferred editor)
# code .
