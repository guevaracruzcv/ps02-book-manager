#!/bin/bash

# Recommendation refinement component.
# Receives candidate recommendations through stdin.
# Removes duplicates and books already present in the library.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATABASE="$SCRIPT_DIR/../data/book_database.sh"

if [[ -t 0 ]]; then
    echo "Error: recommendation data must be provided through stdin." >&2
    exit 1
fi

declare -A SEEN
MAX_RESULTS=8
COUNT=0

while IFS='|' read -r title author genre; do

    # Ignore empty lines.
    if [[ -z "$title" ]]; then
        continue
    fi

    # Build a normalized key for duplicate detection.
    KEY="${title,,}|${author,,}"

    # Skip if this candidate was already processed.
    if [[ -n "${SEEN[$KEY]:-}" ]]; then
        continue
    fi

    SEEN["$KEY"]=1

    # Skip books already present in the personal library.
    if "$DATABASE" exists "$title" "$author" >/dev/null 2>&1; then
        continue
    fi

    echo "$title|$author|$genre"
    COUNT=$((COUNT + 1))

    if [[ "$COUNT" -ge "$MAX_RESULTS" ]]; then
      break
    fi

done