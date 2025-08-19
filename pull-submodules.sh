#!/bin/bash

# A script to iterate through all Git submodules, check out their default branch,
# and pull the latest changes.
#
# USAGE:
#   ./pull-submodules.sh

# --- Main Logic ---
echo "Starting to pull updates for all submodules..."
echo "-------------------------------------------------"

# Use git submodule foreach to iterate through each submodule directory.
git submodule foreach '
  # The $path variable is automatically provided by `git submodule foreach`.
  echo "=> Processing submodule: $path"

  # Find the default branch name from the remote (e.g., main, master).
  # This is a robust way to handle submodules with different default branches.
  DEFAULT_BRANCH=$(git symbolic-ref --short refs/remotes/origin/HEAD | sed "s@^origin/@@")

  if [ -n "$DEFAULT_BRANCH" ]; then
    echo "   Switching to default branch: $DEFAULT_BRANCH"
    git checkout "$DEFAULT_BRANCH"
    
    echo "   Pulling latest changes..."
    git pull
  else
    echo "   Could not determine the default branch for $path. Skipping."
  fi
  
  echo "-------------------------------------------------"
'

echo "Submodule pulling complete."

