#!/bin/bash

# Library management workflow.
# Coordinates book-related operations without directly accessing books.csv.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

DATABASE="$SCRIPT_DIR/../data/book_database.sh"
SEARCH_BOOKS="$SCRIPT_DIR/../books/search_books.sh"
FETCH_METADATA="$SCRIPT_DIR/../books/fetch_book_metadata.sh"

COMMAND="${1:-}"

case "$COMMAND" in

    list)
        "$DATABASE" list
        ;;

    search)
        TERM="${2:-}"

        if [[ -z "$TERM" ]]; then
            echo "Error: search term is required." >&2
            exit 1
        fi

        "$SEARCH_BOOKS" "$TERM"
        ;;

    add)
        TITLE="${2:-}"
        AUTHOR="${3:-}"
        GENRE="${4:-}"
        STATUS="${5:-}"
        RATING="${6:-}"
        LINK="${7:-}"

        if [[ -z "$TITLE" || -z "$AUTHOR" ]]; then
            echo "Error: title and author are required." >&2
            exit 1
        fi

        # Enrich the book when genre was not provided.
        if [[ -z "$GENRE" ]]; then

            METADATA=$("$FETCH_METADATA" "$TITLE" "$AUTHOR")

            IFS='|' read -r \
                META_TITLE \
                META_AUTHOR \
                META_GENRE \
                META_YEAR <<< "$METADATA"

            GENRE="$META_GENRE"

            echo "Metadata found: genre=$META_GENRE, year=$META_YEAR" >&2
        fi

        "$DATABASE" add \
            "$TITLE" \
            "$AUTHOR" \
            "$GENRE" \
            "$STATUS" \
            "$RATING" \
            "$LINK"
        ;;

    *)
        echo "Usage: $0 {list|search|add}"
        exit 1
        ;;
esac
