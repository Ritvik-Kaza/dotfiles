# dotfiles

Personal configuration files for my Arch Linux + Hyprland setup.

## Structure

```
dotfiles/
├── bash/
│   └── .bashrc          # Custom prompt: git-aware, branch + dirty state indicator
├── hypr/
│   ├── hyprland.lua      # Main Hyprland config (Lua-based, Hyprland 0.55+)
│   ├── hyprlock.conf     # Lock screen config
│   ├── hyprpaper.conf    # Wallpaper config
│   └── scripts/
│       ├── dev-session.sh          # Opens Alacritty + tmux with nvim in one window, shell in another
│       ├── power-menu              # Anchors a wlogout popup under the waybar power icon
│       └── screenshots/
│           ├── captureArea.sh
│           └── captureScreen.sh
├── tmux/
│   └── .tmux.conf        # tmux config: custom prefix, mouse support, Alt+number window switching
├── waybar/
│   ├── config.jsonc      # Waybar module configuration
│   └── style.css         # Waybar styling
└── wlogout/
    ├── layout             # Lock / suspend / shutdown buttons
    └── style.css          # Floating dark-pill styling to match waybar
```

## Usage

These are plain copies, not symlinked. To apply a config, copy the relevant file(s) into place manually:

```bash
cp bash/.bashrc ~/.bashrc
cp -r hypr/* ~/.config/hypr/
cp -r waybar/* ~/.config/waybar/
cp -r wlogout/* ~/.config/wlogout/
cp tmux/.tmux.conf ~/.tmux.conf

mkdir -p ~/.local/bin
cp hypr/scripts/power-menu ~/.local/bin/power-menu
chmod +x ~/.local/bin/power-menu ~/.config/hypr/scripts/*.sh
```

Reload as needed (`source ~/.bashrc`, `tmux source-file ~/.tmux.conf`, restart Hyprland/Waybar).

## Notes

- Bash prompt shows `user@host path` outside git repos, and `dirname git:(branch)` (with a `✗` for uncommitted changes) inside git repos.
- Hyprland config uses the newer Lua-based format (`hyprland.lua`), not the legacy `hyprland.conf`.
- `mainMod + N` in Hyprland runs `dev-session.sh`, opening Alacritty with a tmux session: window 1 = `nvim .`, window 2 = plain shell, focused on window 1.
- tmux prefix is `Ctrl+A` (remapped from default `Ctrl+B`). Windows can also be switched directly with `Alt+1` through `Alt+9`, no prefix needed, and 'Alt + Tab' can be used to switch to the previous window.
- Waybar is styled as individually floating, semi-transparent pills rather than one solid bar; pairs with the `blur` layer rules in `hyprland.lua` for the waybar and wlogout namespaces.
- Clicking the power icon in waybar runs `power-menu`, which opens a small wlogout popup (lock / suspend / shutdown) anchored under the icon instead of a fullscreen menu. Requires `wlogout` and `jq`.
