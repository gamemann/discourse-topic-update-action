#!/bin/bash

set -e

# Retrieve full path to script directory.
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

ENV_FILE="$1"
FILE="$2"
VERBOSE="$3"

if [[ -z "$VERBOSE" ]]; then
    VERBOSE="1"
fi

# Ensure 
if [[ -z "$FILE" ]]; then
    echo "❌ Error: File name not supplied to 'process_contents.sh'!"

    exit 1
fi

# Check if file exists.
if [[ ! -f "$FILE" ]]; then
    echo "❌ Error: File '$FILE' does not exist."

    exit 1
fi

# Load environmental file if any.
if [[ -f "$ENV_FILE" ]]; then
    set -a
    source "$ENV_FILE"
    set +a
fi

# Create temp file.
TMP_FILE=$(mktemp)

# Process and fix links using `gawk`.
gawk -f "$SCRIPT_DIR/fix_links.awk" "$FILE" > "$TMP_FILE"

# Remove line numbers if LINES_SKIP env variable is set.
if [[ -n "$LINES_SKIP" ]]; then
    if [[ "$VERBOSE" -ge 1 ]]; then
        echo "Removing line(s): $LINES_SKIP"
    fi

    IFS=',' read -ra LINES <<< "$LINES_SKIP"
    for line in "${LINES[@]}"; do
        echo "$line"
    done | sort -nr | while read -r lineno; do
        sed -i "${lineno}d" "$TMP_FILE"
    done
fi

cat "$TMP_FILE"

# Eh why not?
rm -f "$TMP_FILE"