#!/usr/bin/env bash
# Copies every config in this repo into place on a fresh machine, mirroring
# the README's Usage section exactly. Plain copies, not symlinks -- same as
# doing it by hand. Safe to re-run; it just overwrites with the repo's copy.
#
# Directory-level copies (cp -r) pick up new files automatically -- nothing
# here needs updating when a script gets added inside an existing folder.
# The ~/.local/bin list below is the one exception: it's the short, rarely-
# changing set of scripts that need to be callable by bare name (from
# wlogout actions, etc.) rather than by full path. Most new scripts don't
# need this at all -- they're invoked via their full ~/.config/hypr/scripts
# path directly in hyprland.lua's binds instead.

set -euo pipefail

cd "$(dirname "$0")"

cp bash/.bashrc ~/.bashrc
mkdir -p ~/.config/nvim
cp nvim/init.lua ~/.config/nvim/init.lua
mkdir -p ~/.config/hypr ~/.config/waybar ~/.config/wlogout ~/.config/rofi \
         ~/.config/theme-switcher ~/.config/alacritty ~/.config/swappy
cp -r hypr/* ~/.config/hypr/
cp -r waybar/* ~/.config/waybar/
cp -r wlogout/* ~/.config/wlogout/
cp -r rofi/* ~/.config/rofi/
cp -r theme-switcher/* ~/.config/theme-switcher/
cp -r theme-presets ~/.config/theme-presets
cp -r alacritty/* ~/.config/alacritty/
cp -r swappy/* ~/.config/swappy/
cp tmux/.tmux.conf ~/.tmux.conf

mkdir -p ~/.local/bin
cp hypr/scripts/power-menu ~/.local/bin/power-menu
cp hypr/scripts/theme-switch ~/.local/bin/theme-switch
cp hypr/scripts/theme-menu ~/.local/bin/theme-menu
cp hypr/scripts/hyprpaper-init ~/.local/bin/hyprpaper-init
cp hypr/scripts/webapp-install ~/.local/bin/webapp-install
chmod +x ~/.local/bin/power-menu ~/.local/bin/theme-switch ~/.local/bin/theme-menu \
         ~/.local/bin/hyprpaper-init ~/.local/bin/webapp-install
# Recursive, not a *.sh glob -- covers screenshots/ and the extensionless
# scripts (find-text, fullscreen-aware-focus, volume-step) too, and needs no
# updating when a new script is added anywhere under this tree.
chmod -R +x ~/.config/hypr/scripts/

echo "Done. Reload as needed: source ~/.bashrc, tmux source-file ~/.tmux.conf, restart Hyprland/Waybar."
