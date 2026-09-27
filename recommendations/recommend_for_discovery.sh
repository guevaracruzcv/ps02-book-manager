#!/bin/bash

# Recommends books intentionally outside the user's normal patterns.
# The goal is exploration rather than similarity.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATABASE="$SCRIPT_DIR/../data/book_database.sh"

# Small delay so parallel execution remains visible.
sleep 4

# Recommend areas that are not strongly represented
# in the current personal library.

if ! "$DATABASE" search "Literary Fiction" | grep -q .; then
    echo "Invisible Cities|Italo Calvino|Literary Fiction"
fi

if ! "$DATABASE" search "Biography" | grep -q .; then
    echo "Steve Jobs|Walter Isaacson|Biography"
fi

if ! "$DATABASE" search "Psychology" | grep -q .; then
    echo "Thinking, Fast and Slow|Daniel Kahneman|Psychology"
fi

if ! "$DATABASE" search "History" | grep -q .; then
    echo "Sapiens|Yuval Noah Harari|History"
fi