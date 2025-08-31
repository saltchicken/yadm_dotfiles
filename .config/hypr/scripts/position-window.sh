#!/bin/sh
pos=$(echo "center\ntop-left\nlower-left\ntop-right\nlower-right" | wofi --dmenu --prompt "Select position:")
case "$pos" in
"top-left") hyprctl --batch "dispatch setfloating 1; dispatch resizeactive exact 1280 720; dispatch moveactive exact 0 0" ;;
"lower-left") hyprctl --batch "dispatch setfloating 1; dispatch resizeactive exact 1280 720; dispatch moveactive exact 0 720" ;;
"top-right") hyprctl --batch "dispatch setfloating 1; dispatch resizeactive exact 1280 720; dispatch moveactive exact 3840 0" ;;
"lower-right") hyprctl --batch "dispatch setfloating 1; dispatch resizeactive exact 1280 720; dispatch moveactive exact 3840 720" ;;
"center") hyprctl --batch "dispatch setfloating 1; dispatch resizeactive exact 2560 1440; dispatch moveactive exact 1280 0" ;;
esac
