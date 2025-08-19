#!/bin/bash

# A script to find modified Git submodules, then add, commit, and push them.
#
# USAGE:
#   ./push-submodules.sh "Your custom commit message"
#
# If no commit message is provided, a default one will be used.

# --- Configuration ---
# Use the first argument as the commit message, or use a default.
COMMIT_MESSAGE="${1:-Automated submodule update}"

# --- Main Logic ---
echo "Searching for modified submodules..."
echo "Using commit message: \"$COMMIT_MESSAGE\""
echo "-------------------------------------------------"

# Use git submodule foreach to iterate through each submodule directory.
git submodule foreach '
  # Check if there are any changes (untracked, modified, etc.)
  if [ -n "$(git status --porcelain)" ]; then
    # If changes exist, print the path and process them.
    # The $path variable is automatically provided by `git submodule foreach`.
    echo "=> Found changes in $path, processing..."
    git add .
    git commit -m "'"$COMMIT_MESSAGE"'"
    git push
    echo "=> Pushed changes for $path."
  else
    # If no changes, print the path and skip.
    echo "=> No changes in $path, skipping."
  fi
  echo "-------------------------------------------------"
'

echo "Submodule processing complete."