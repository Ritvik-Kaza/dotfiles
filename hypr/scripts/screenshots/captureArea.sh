#!/bin/bash
DIR="$(xdg-user-dir PICTURES)/Screenshots"
mkdir -p "$DIR"
GEOM="$(slurp)"
[ -z "$GEOM" ] && exit 0
FILE="$DIR/$(date +'%Y-%m-%d_%H-%M-%S').png"
grim -g "$GEOM" "$FILE"
wl-copy < "$FILE"
notify-send "Screenshot saved" "$FILE"
