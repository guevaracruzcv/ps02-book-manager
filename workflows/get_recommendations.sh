#!/bin/bash

# Recommendation workflow.
# Runs three recommendation strategies in parallel,
# waits for completion, combines their outputs,
# and sends the result through the refinement pipeline.

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

HISTORY="$SCRIPT_DIR/../recommendations/recommend_from_history.sh"
INTERESTS="$SCRIPT_DIR/../recommendations/recommend_from_interests.sh"
DISCOVERY="$SCRIPT_DIR/../recommendations/recommend_for_discovery.sh"
REFINE="$SCRIPT_DIR/../recommendations/refine_recommendations.sh"

TMP_DIR=$(mktemp -d)

HISTORY_OUT="$TMP_DIR/history.txt"
INTERESTS_OUT="$TMP_DIR/interests.txt"
DISCOVERY_OUT="$TMP_DIR/discovery.txt"

HISTORY_CLEAN="$TMP_DIR/history_clean.txt"
INTERESTS_CLEAN="$TMP_DIR/interests_clean.txt"
DISCOVERY_CLEAN="$TMP_DIR/discovery_clean.txt"

echo "Starting recommendation agents..." >&2

"$HISTORY" > "$HISTORY_OUT" &
PID1=$!

"$INTERESTS" > "$INTERESTS_OUT" &
PID2=$!

"$DISCOVERY" > "$DISCOVERY_OUT" &
PID3=$!

echo "History agent running...   PID $PID1" >&2
echo "Interests agent running... PID $PID2" >&2
echo "Discovery agent running... PID $PID3" >&2

echo >&2
echo "Recommendation agents are working..." >&2

wait "$PID1"
echo "History agent done." >&2

wait "$PID2"
echo "Interests agent done." >&2

wait "$PID3"
echo "Discovery agent done." >&2

echo >&2
echo "All agents finished." >&2
echo >&2

# Refine each agent's output independently first.
"$REFINE" < "$HISTORY_OUT" > "$HISTORY_CLEAN"
"$REFINE" < "$INTERESTS_OUT" > "$INTERESTS_CLEAN"
"$REFINE" < "$DISCOVERY_OUT" > "$DISCOVERY_CLEAN"

# Balanced aggregation:
# up to 3 from history, 3 from interests, and 2 from discovery.
{
    head -n 3 "$HISTORY_CLEAN"
    head -n 3 "$INTERESTS_CLEAN"
    head -n 2 "$DISCOVERY_CLEAN"
} | "$REFINE"

rm -rf "$TMP_DIR"
