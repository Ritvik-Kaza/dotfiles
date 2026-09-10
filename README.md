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

## Dependencies

Everything below is for Arch Linux (`pacman`/AUR). Install what corresponds to the configs you're actually using.

**Core (used by more than one config, or required for the setup to function at all):**
```bash
sudo pacman -S hyprland waybar alacritty tmux neovim git \
               ttf-cascadia-mono-nerd
```

**hypr/**
```bash
sudo pacman -S hyprlock hyprpaper grim slurp wl-clipboard jq
```
- `grim` + `slurp`: used by `hypr/scripts/screenshots/captureArea.sh` and `captureScreen.sh`.
- `jq`: used by `hypr/scripts/power-menu` to read monitor geometry from `hyprctl`.
- Hyprland 0.55+ is required for the Lua config format (`hyprland.lua`); older versions expect `hyprland.conf` and won't read this repo's config.

**waybar/**
```bash
sudo pacman -S bluez bluez-utils pavucontrol
sudo pacman -S blueman   # or: yay -S blueberry
sudo systemctl enable --now bluetooth
```
- `bluez` / `bluez-utils`: backend for the waybar bluetooth module.
- `pavucontrol`: opened by clicking the volume module.
- `blueman` (or `blueberry` from the AUR): opened by clicking the bluetooth module.
- Network module click opens `alacritty -e nmtui`, which needs NetworkManager (`sudo pacman -S networkmanager`, `sudo systemctl enable --now NetworkManager`). Using `iwd` instead requires editing that line in `config.jsonc`.

**wlogout/**
```bash
yay -S wlogout
```
- AUR only — needs `yay` or `paru`.
- The lock button runs `hyprlock`; the suspend button runs `hyprlock` then `systemctl suspend`, so `hyprlock.conf` must actually be configured or the buttons will appear to do nothing.

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
- `hyprlock.conf` is a minimal centered theme: large clock, date, greeting, and a translucent password pill, all vertically centered; battery percentage sits small in the top-right corner. Background is the normal wallpaper blurred at lock time via hyprlock's own `blur_passes`/`blur_size`, not a separate pre-blurred image. The password field's outline turns amber (`capslock_color`) when caps lock is on. Battery path assumes `BAT0` — check `/sys/class/power_supply/` if yours differs.
