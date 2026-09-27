#!/bin/bash

# Main user interface for the Book Manager.
# Handles user interaction and delegates work to workflows.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

MANAGE_LIBRARY="$SCRIPT_DIR/../workflows/manage_library.sh"
LIBRARY_SCREEN="$SCRIPT_DIR/library_screen.sh"

GET_RECOMMENDATIONS="$SCRIPT_DIR/../workflows/get_recommendations.sh"
RECOMMENDATIONS_SCREEN="$SCRIPT_DIR/recommendations_screen.sh"

gum style \
    --border rounded \
    --padding "0 1" \
    --margin "1 0" \
    "Personal Book Manager" \
    "Technology • Governance • Development • Discovery"

while true; do


    CHOICE=$(gum choose \
        "Browse Library" \
        "Search Library" \
        "Add Book" \
        "Get Recommendations" \
        "Quit")

    case "$CHOICE" in

        "Browse Library")
            "$MANAGE_LIBRARY" list | "$LIBRARY_SCREEN"
            ;;

        "Search Library")
            TERM=$(gum input --placeholder "Enter title, author, genre, or keyword")

            if [[ -n "$TERM" ]]; then
                "$MANAGE_LIBRARY" search "$TERM" | "$LIBRARY_SCREEN"
            fi
            ;;

        "Add Book")
            TITLE=$(gum input --placeholder "Book title")
            AUTHOR=$(gum input --placeholder "Author")
            GENRE=$(gum input --placeholder "Genre")

            STATUS=$(gum choose \
                "want-to-read" \
                "reading" \
                "finished")

            RATING=$(gum input --placeholder "Rating (1-5)")
            LINK=$(gum input --placeholder "Link (optional)")

            "$MANAGE_LIBRARY" add \
                "$TITLE" \
                "$AUTHOR" \
                "$GENRE" \
                "$STATUS" \
                "$RATING" \
                "$LINK"
            ;;

        "Get Recommendations")
            "$GET_RECOMMENDATIONS" | "$RECOMMENDATIONS_SCREEN"
            ;;

        "Quit")
            echo "Goodbye."
            break
            ;;

    esac

done