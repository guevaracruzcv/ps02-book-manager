#!/bin/bash

# Book metadata enrichment component.
# Receives a title and author and returns enriched book information.

TITLE="${1:-}"
AUTHOR="${2:-}"

if [[ -z "$TITLE" || -z "$AUTHOR" ]]; then
    echo "Error: title and author are required." >&2
    exit 1
fi

case "$TITLE" in

    "Dune")
        GENRE="Science Fiction"
        YEAR="1965"
        ;;

    "1984")
        GENRE="Dystopian Fiction"
        YEAR="1949"
        ;;

    "The Innovator's Dilemma")
        GENRE="Business"
        YEAR="1997"
        ;;

    "The Coming Wave")
        GENRE="Technology"
        YEAR="2023"
        ;;

    *)
        GENRE="Unknown"
        YEAR="Unknown"
        ;;

esac

echo "$TITLE|$AUTHOR|$GENRE|$YEAR"
