#!/bin/bash

# Recommends books based on the user's stated interests.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
INTERESTS_FILE="$SCRIPT_DIR/../data/interests.txt"

# Small delay so parallel execution remains visible.
sleep 5

if [[ ! -f "$INTERESTS_FILE" ]]; then
    echo "Error: interests file not found." >&2
    exit 1
fi

while IFS= read -r interest || [[ -n "$interest" ]]; do

  # Remove Windows carriage return if present.
    interest="${interest%$'\r'}"

    case "$interest" in

        "Artificial Intelligence")
            echo "The Alignment Problem|Brian Christian|Artificial Intelligence"
            ;;

        "Digital Governance")
            echo "Digital Government|Darrell M. West|Digital Governance"
            ;;

        "Technology Policy")
            echo "The Coming Wave|Mustafa Suleyman|Technology Policy"
            ;;

        "Public Sector Innovation")
            echo "The Entrepreneurial State|Mariana Mazzucato|Public Sector Innovation"
            ;;

        "Development")
            echo "Why Nations Fail|Daron Acemoglu and James A. Robinson|Development"
            ;;

        "Leadership")
            echo "Good Strategy Bad Strategy|Richard Rumelt|Leadership"
            ;;

    esac

done < "$INTERESTS_FILE"