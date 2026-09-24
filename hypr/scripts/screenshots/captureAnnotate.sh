#!/bin/bash
GEOM="$(slurp)"
[ -z "$GEOM" ] && exit 0
grim -g "$GEOM" - | swappy -f -
