#!/bin/bash
GEOM="$(slurp)"
[ -z "$GEOM" ] && exit 0
grim -g "$GEOM" - | tesseract - - 2>/dev/null | wl-copy
notify-send "Text copied to clipboard"
