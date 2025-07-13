#!/bin/bash
# Simple script to process input and return it.
# The first argument ($1) will be the text entered in the tmux prompt.
# gemini --prompt "$1"
source /home/saltchicken/.config/tmux/scripts/.venv/bin/activate
python /home/saltchicken/.config/tmux/scripts/request.py "$1"
# echo "$1"
