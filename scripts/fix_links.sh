#!/bin/bash

set -e

ENV_FILE="$1"

FILE="$2"

# Check if file exists.
if [[ ! -f "$FILE" ]]; then
    echo "❌ Error: File '$FILE' does not exist."

    exit 1
fi

# Load the env vars from the .env file
if [[ -f "$ENV_FILE" ]]; then
    set -a
    source "$ENV_FILE"
    set +a
fi

# Run AWK with access to the env vars
gawk -v ENVIRON=ENVIRON -f ./scripts/fix_links.awk "$FILE"