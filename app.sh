#!/bin/bash

# Personal Book Manager
# Application entry point.
# Starts the application and delegates interaction to the UI layer.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
MAIN_MENU="$SCRIPT_DIR/ui/main_menu.sh"

# Verify that Gum is available.
if ! command -v gum >/dev/null 2>&1; then
    echo "Error: Gum is required to run this application." >&2
    exit 1
fi

# Launch the application.
"$MAIN_MENU"
