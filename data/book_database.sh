#!/bin/bash

# Data abstraction layer.
# This is the only application component that directly accesses books.csv.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DB_FILE="$SCRIPT_DIR/books.csv"

sanitize_field() {
    local value="$1"

    # Normalize characters that could break the CSV structure.
    value="${value//$'\r'/ }"
    value="${value//$'\n'/ }"
    value="${value//,/;}"

    printf '%s' "$value"
}

book_exists() {
   local title
local author

title=$(sanitize_field "$1")
author=$(sanitize_field "$2")

    awk -F',' \
        -v title="$title" \
        -v author="$author" \
        'NR > 1 &&
         tolower($1) == tolower(title) &&
         tolower($2) == tolower(author) {
             found = 1
         }
         END {
             exit !found
         }' "$DB_FILE"
}


COMMAND="${1:-}"

case "$COMMAND" in

    search)
        TERM="${2:-}"

        if [[ -z "$TERM" ]]; then
            echo "Error: search term is required." >&2
            exit 1
        fi

        awk -F',' -v term="$TERM" '
            NR > 1 {
                line = tolower($0)
                search = tolower(term)

                if (index(line, search) > 0) {
                    print
                }
            }
        ' "$DB_FILE"
        ;;

    list)
        cat "$DB_FILE"
        ;;

    exists)

        TITLE="${2:-}"
        AUTHOR="${3:-}"

        if [[ -z "$TITLE" || -z "$AUTHOR" ]]; then
            echo "Error: title and author are required."
            exit 1
        fi

        if book_exists "$TITLE" "$AUTHOR"; then
            echo "yes"
        else
            echo "no"
            exit 1
        fi
        ;;

    add)
        TITLE="${2:-}"
        AUTHOR="${3:-}"
        GENRE="${4:-}"
        STATUS="${5:-}"
        RATING="${6:-}"
        LINK="${7:-}"

        if [[ -z "$TITLE" || -z "$AUTHOR" ]]; then
            echo "Error: title and author are required."
            exit 1
        fi

        TITLE=$(sanitize_field "$TITLE")
        AUTHOR=$(sanitize_field "$AUTHOR")
        GENRE=$(sanitize_field "$GENRE")
        STATUS=$(sanitize_field "$STATUS")
        RATING=$(sanitize_field "$RATING")
        LINK=$(sanitize_field "$LINK")

        if book_exists "$TITLE" "$AUTHOR"; then
            echo "Error: book already exists: $TITLE by $AUTHOR"
            exit 1
        fi

        printf '%s,%s,%s,%s,%s,%s\n' \
            "$TITLE" \
            "$AUTHOR" \
            "$GENRE" \
            "$STATUS" \
            "$RATING" \
            "$LINK" >> "$DB_FILE"

        echo "Book added: $TITLE by $AUTHOR"
        ;;

    *)
        echo "Usage: $0 {list|exists|search|add}"
        exit 1
        ;;
esac