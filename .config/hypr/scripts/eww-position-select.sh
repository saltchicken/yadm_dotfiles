#!/bin/sh

hyprctl monitors -j | jq -r '
    .[] 
    | select(.focused) 
    | "hyprctl dispatch movecursor \((.x + (.width / 2)) | round) \((.y + (.height / 2)) | round)"
' | sh
eww open position_hud
