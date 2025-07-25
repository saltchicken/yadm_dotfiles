#!/bin/sh

# Only run if inside a terminal
if [ -n "$TMUX" ]; then
  printf "\ePtmux;\e\e]52;c;%s\a\e\\" "$(base64 | tr -d '\n')"
else
  printf "\e]52;c;%s\a" "$(base64 | tr -d '\n')"
fi
