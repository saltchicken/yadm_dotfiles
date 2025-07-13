#!/bin/bash

PROMPT_FILE=$(mktemp)
SYSTEM_MESSAGE_FILE=$(mktemp)
trap 'rm -f "$PROMPT_FILE" "$SYSTEM_MESSAGE_FILE"' EXIT

echo "System message content" >"$SYSTEM_MESSAGE_FILE"

nvim -c 'set nonumber norelativenumber wrap' \
  -c "split $PROMPT_FILE" \
  -c 'command! Send wa | qall' \
  "$SYSTEM_MESSAGE_FILE" >/dev/tty </dev/tty

CONTENT=$(cat "$PROMPT_FILE")
SYSTEM_MESSAGE=$(cat "$SYSTEM_MESSAGE_FILE")

OUTPUT=$(/home/saltchicken/.config/tmux/scripts/process_input.sh "$CONTENT")

OUTPUT_TMPFILE=$(mktemp)
trap 'rm -f "$OUTPUT_TMPFILE"' EXIT

echo "$OUTPUT" >"$OUTPUT_TMPFILE"

# sleep 4

nvim -c 'set nonumber norelativenumber wrap' "$OUTPUT_TMPFILE" >/dev/tty </dev/tty
