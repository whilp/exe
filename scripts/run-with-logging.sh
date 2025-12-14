#!/bin/bash
set -euo pipefail

# Usage: ./run-with-logging.sh <script-to-run> [args...]
# This wrapper runs a script and logs its output to logs/

SCRIPT_NAME=$(basename "$1" .sh)
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
LOG_DIR="logs"
LOG_FILE="$LOG_DIR/${SCRIPT_NAME}-${TIMESTAMP}.log"

# Create logs directory
mkdir -p "$LOG_DIR"

echo "Running $1 with logging to $LOG_FILE"
echo "========================================"

# Run the script with tee to capture output
"$@" 2>&1 | tee "$LOG_FILE"

# Capture exit status
EXIT_CODE=${PIPESTATUS[0]}

echo ""
echo "========================================"
echo "Script completed with exit code: $EXIT_CODE"
echo "Log saved to: $LOG_FILE"

exit $EXIT_CODE
