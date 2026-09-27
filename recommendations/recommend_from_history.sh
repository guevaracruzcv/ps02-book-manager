#!/bin/bash

# Recommends books based on genres already present
# in the user's personal library.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
DATABASE="$SCRIPT_DIR/../data/book_database.sh"

# Small delay so parallel execution remains visible.
sleep 3

FOUND=false

if "$DATABASE" search "Science Fiction" | grep -q .; then
    echo "Foundation|Isaac Asimov|Science Fiction"
    echo "The Left Hand of Darkness|Ursula K. Le Guin|Science Fiction"
    FOUND=true
fi

if "$DATABASE" search "Technology" | grep -q .; then
    echo "The Alignment Problem|Brian Christian|Artificial Intelligence"
    FOUND=true
fi

if "$DATABASE" search "Business" | grep -q .; then
    echo "Good Strategy Bad Strategy|Richard Rumelt|Business"
    FOUND=true
fi

if "$DATABASE" search "Dystopian Fiction" | grep -q .; then
    echo "Brave New World|Aldous Huxley|Dystopian Fiction"
    FOUND=true
fi

if [[ "$FOUND" == false ]]; then
    echo "The Pragmatic Programmer|Andrew Hunt and David Thomas|Technology"
fi