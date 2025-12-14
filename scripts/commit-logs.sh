#!/bin/bash
set -euo pipefail

# Script to commit logs to the logs branch
# Usage: ./commit-logs.sh

ORIGINAL_BRANCH=$(git rev-parse --abbrev-ref HEAD)

echo "Committing logs from $PWD/logs to logs branch"

# Configure git
git config --global user.name "github-actions[bot]"
git config --global user.email "github-actions[bot]@users.noreply.github.com"

# Create or switch to logs branch
git fetch origin logs:logs 2>/dev/null || git checkout --orphan logs || git checkout logs

# If we're on a new orphan branch, clear it
if [ "$(git rev-parse --abbrev-ref HEAD)" = "logs" ] && [ -z "$(git log -1 2>/dev/null)" ]; then
    git rm -rf . 2>/dev/null || true
fi

# Ensure we're on logs branch
git checkout logs 2>/dev/null || git checkout --orphan logs

# Copy logs from original location
if [ -d "../logs" ]; then
    mkdir -p logs
    cp -r ../logs/* logs/ 2>/dev/null || true
fi

# Add and commit logs
if [ -d "logs" ] && [ -n "$(ls -A logs)" ]; then
    git add logs/
    if git diff --staged --quiet; then
        echo "No new logs to commit"
    else
        git commit -m "Build logs from $(date +%Y%m%d-%H%M%S)"
        echo "Logs committed to logs branch"
    fi
else
    echo "No logs found to commit"
fi

# Push logs branch
git push -u origin logs || echo "Failed to push logs branch"

# Return to original branch
git checkout "$ORIGINAL_BRANCH"
echo "Returned to branch: $ORIGINAL_BRANCH"
