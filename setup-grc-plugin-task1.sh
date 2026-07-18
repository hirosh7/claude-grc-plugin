#!/bin/bash
# Task 1: Create local and GitHub repo for grc-plugin
# Run: bash setup-grc-plugin-task1.sh

set -e
mkdir -p ~/projects/grc-plugin
cd ~/projects/grc-plugin
git init

gh repo create hirosh7/grc-plugin --public --description "GRC domain knowledge Cursor plugin"

git remote add origin git@github.com:hirosh7/grc-plugin.git

echo ""
echo "--- Done. Verifying ---"
git remote -v
