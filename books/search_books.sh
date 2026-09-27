#!/bin/bash

# Book search component.
# Receives a search term and delegates the actual data access
# to the data abstraction layer.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATABASE="$SCRIPT_DIR/../data/book_database.sh"

TERM="${1:-}"

# If no argument was provided, try to read the search term from stdin.
if [[ -z "$TERM" && ! -t 0 ]]; then
    read -r TERM
fi

if [[ -z "$TERM" ]]; then
    echo "Error: search term is required." >&2
    exit 1
fi

"$DATABASE" search "$TERM"
