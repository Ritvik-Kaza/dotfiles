# dotfiles

Personal configuration files for my Arch Linux + Hyprland setup. (work in progress)

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
│       └── screenshots/
│           ├── captureArea.sh
│           └── captureScreen.sh
└── waybar/
    ├── config.jsonc      # Waybar module configuration
    └── style.css         # Waybar styling
```

## Usage

These are plain copies, not symlinked. To apply a config, copy the relevant file(s) into place manually:

```bash
cp bash/.bashrc ~/.bashrc
cp -r hypr/* ~/.config/hypr/
cp -r waybar/* ~/.config/waybar/
```

Reload as needed (`source ~/.bashrc`, restart Hyprland/Waybar).

## Notes

- Bash prompt shows `user@host path` outside git repos, and `dirname git:(branch)` (with a `✗` for uncommitted changes) inside git repos.
- Hyprland config uses the newer Lua-based format (`hyprland.lua`), not the legacy `hyprland.conf`.
