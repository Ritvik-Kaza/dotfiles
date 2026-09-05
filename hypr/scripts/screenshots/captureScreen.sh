#!/bin/bash
DIR="$(xdg-user-dir PICTURES)/Screenshots"
mkdir -p "$DIR"
FILE="$DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"
grim -o "$(hyprctl activeworkspace -j | jq -r '.monitor')" "$FILE"
wl-copy < "$FILE"
notify-send "Screenshot saved" "$FILE"
