#!/bin/bash

# Library presentation layer.
# Receives library data through stdin and presents it to the user.

if [[ -t 0 ]]; then
    echo "No library data received." >&2
    exit 1
fi

gum style \
    --border rounded \
    --padding "0 1" \
    --margin "1 0" \
    "My Library"

while IFS=',' read -r title author genre status rating link || [[ -n "$title" ]]; do

    # Ignore the CSV header.
    if [[ "$title" == "title" ]]; then
        continue
    fi

    # Ignore blank lines.
    if [[ -z "$title" ]]; then
        continue
    fi

    echo "Title : $title"
    echo "Author: $author"
    echo "Genre : $genre"
    echo "Status: $status"
    echo "Rating: $rating"

    if [[ -n "$link" ]]; then
        echo "Link  : $link"
    fi

    echo "------------------------------"

done
