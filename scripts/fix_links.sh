#!/bin/bash

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ENV_FILE="$1"
FILE="$2"

if [[ -z "$FILE" ]]; then
    echo "⚠️ Found no input file to parse from caller. Defaulting to README.md..."

    FILE="README.md"
fi

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
gawk -f "$SCRIPT_DIR/fix_links.awk" "$FILE"