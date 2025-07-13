#!/bin/bash

TMPFILE=$(mktemp)
trap 'rm -f "$TMPFILE"' EXIT

nvim -c 'set nonumber norelativenumber wrap' "$TMPFILE" >/dev/tty </dev/tty

CONTENT=$(cat "$TMPFILE")

OUTPUT=$(/home/saltchicken/.config/tmux/scripts/process_input.sh "$CONTENT")

OUTPUT_TMPFILE=$(mktemp)
trap 'rm -f "$OUTPUT_TMPFILE"' EXIT

echo "$OUTPUT" >"$OUTPUT_TMPFILE"

sleep 4

nvim -c 'set nonumber norelativenumber wrap' "$OUTPUT_TMPFILE" >/dev/tty </dev/tty
