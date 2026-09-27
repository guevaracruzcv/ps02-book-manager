#!/bin/bash

# Recommendation presentation layer.
# Receives recommendation data through stdin.
# Waits for the complete result before rendering the UI.

if [[ -t 0 ]]; then
    echo "No recommendation data received." >&2
    exit 1
fi

# Read all recommendations first.
mapfile -t RECOMMENDATIONS

# Only render the screen after the workflow has finished.
gum style \
    --border rounded \
    --padding "0 1" \
    --margin "1 0" \
    "Recommended for You"

for recommendation in "${RECOMMENDATIONS[@]}"; do

    if [[ -z "$recommendation" ]]; then
        continue
    fi

    IFS='|' read -r title author genre <<< "$recommendation"

    echo "Title : $title"
    echo "Author: $author"
    echo "Genre : $genre"
    echo "------------------------------"

done