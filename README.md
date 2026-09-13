# dotfiles

Personal configuration files for my Arch Linux + Hyprland setup.

## Structure

```
dotfiles/
├── alacritty/
│   └── alacritty.toml     # Base terminal config: dark theme colors, opacity, font
├── bash/
│   └── .bashrc          # Custom prompt: git-aware, branch + dirty state indicator
├── hypr/
│   ├── hyprland.lua      # Main Hyprland config (Lua-based, Hyprland 0.55+)
│   ├── hyprlock.conf     # Lock screen config
│   ├── hyprpaper.conf    # Wallpaper config
│   └── scripts/
│       ├── dev-session.sh          # Opens Alacritty + tmux with nvim in one window, shell in another
│       ├── power-menu              # Anchors a wlogout popup under the waybar power icon
│       ├── theme-switch            # Copies a theme preset's files into place, reloads waybar/hyprpaper
│       ├── theme-menu              # Anchors the theme-picker wlogout popup under the waybar theme icon
│       └── screenshots/
│           ├── captureArea.sh
│           └── captureScreen.sh
├── tmux/
│   └── .tmux.conf        # tmux config: custom prefix, mouse support, Alt+number window switching
├── rofi/
│   ├── config.rasi        # Rofi config: drun mode, icons, font
│   └── theme.rasi          # Dark floating-pill theme matching waybar/wlogout
├── theme-presets/
│   ├── dark/              # Default theme: 8 files — waybar/wlogout/rofi/hyprlock/alacritty/hyprpaper/theme-switcher/mako
│   ├── rose/              # Dusty-rose accent theme, same 8 files, wallpaper3
│   ├── nokron/            # Violet/indigo with warm gold accent, same 8 files, wallpaper4
│   └── krat/              # Steel-grey base, teal/magenta accents, gothic-noir wallpaper5
├── theme-switcher/
│   ├── layout             # wlogout layout for the theme picker (Dark / Rose / Nokron / Krat buttons)
│   └── style.css          # Matches wlogout/style.css styling
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
               ttf-cascadia-mono-nerd fzf fd bat
```
- `fzf` / `fd` / `bat`: fuzzy file finder used from Bash (Ctrl+T / Alt+C) and by the Super+Shift+F floating popup below.

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

**rofi/**
```bash
sudo pacman -S rofi papirus-icon-theme
```
- `papirus-icon-theme`: `config.rasi` sets `icon-theme: "Papirus-Dark"`; swap the name if you use a different icon set.

**theme-switcher/ and theme-presets/**
```bash
sudo pacman -S mako
```
No other new packages — everything else needed (`hyprctl`, `pkill`, `setsid`) ships with `hyprland` and `util-linux`. `mako` is the notification daemon each preset's `mako-config` themes; only one notification daemon should own the D-Bus `org.freedesktop.Notifications` service at a time, so if you already run `dunst` or `swaync`, either switch to mako or skip this file and theme your existing daemon instead. Confirm which one is actually active with `busctl --user list | grep -i notif`. `setsid` is required specifically to detach the switch script from wlogout's process — wlogout exits immediately after a button click and will kill any still-attached child process before it finishes, which is why the picker's `action` fields wrap the command in `setsid sh -c '...'` rather than calling `theme-switch` directly.

## Hardcoded values

These are machine-specific literals baked into the configs. Anyone reusing this repo will need to change these two:

- **`hypr/hyprlock.conf`** — `$wallpaper` is set to `~/Pictures/Wallpapers/wallpaper2.png`.
- **`hypr/hyprlock.conf`** — battery path is `/sys/class/power_supply/BAT0/capacity`; check `/sys/class/power_supply/` if your battery has a different name (or remove the label if there's no battery at all).
- **`theme-presets/dark/`** — wallpaper is `wallpaper2.png`; **`theme-presets/rose/`** — wallpaper is `wallpaper3.jpeg`; **`theme-presets/nokron/`** — wallpaper is `wallpaper4.png`; **`theme-presets/krat/`** — wallpaper is `wallpaper5.jpeg`. Both `hyprlock.conf` and `hyprpaper.conf` in each preset must agree on the path, since `theme-switch` reads the wallpaper path *from* the preset's `hyprlock.conf` to feed to `hyprctl hyprpaper`.
- **Duplication risk, not a bug:** `waybar/style.css`, `wlogout/style.css`, and `rofi/theme.rasi` at the top level are mirrored inside `theme-presets/dark/` with the same content. The top-level copies are what a fresh install starts from; the preset copies are what `theme-switch dark` restores. Editing one without the other means a future `theme-switch dark` will silently revert a direct edit to the top-level file — after tweaking colors directly, either update the matching preset file too or just run `theme-switch dark` to resync.

## Usage

These are plain copies, not symlinked. To apply a config, copy the relevant file(s) into place manually:

```bash
cp bash/.bashrc ~/.bashrc
cp -r hypr/* ~/.config/hypr/
cp -r waybar/* ~/.config/waybar/
cp -r wlogout/* ~/.config/wlogout/
cp -r rofi/* ~/.config/rofi/
cp -r theme-switcher/* ~/.config/theme-switcher/
cp -r theme-presets ~/.config/theme-presets
cp -r alacritty/* ~/.config/alacritty/
cp tmux/.tmux.conf ~/.tmux.conf

mkdir -p ~/.local/bin
cp hypr/scripts/power-menu ~/.local/bin/power-menu
cp hypr/scripts/theme-switch ~/.local/bin/theme-switch
cp hypr/scripts/theme-menu ~/.local/bin/theme-menu
chmod +x ~/.local/bin/power-menu ~/.local/bin/theme-switch ~/.local/bin/theme-menu ~/.config/hypr/scripts/*.sh
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
- `Super + Shift + F` opens a small floating Alacritty window running `fzf` piped into `nvim`, for fuzzy-finding and opening any file under `$HOME`. Floating, resizing (560×320), and centering are handled by a `window.open` event handler in `hyprland.lua`, not a static window rule — the popup gets its own opacity override too, applied via a widened `Alacritty|alacritty-fzf` regex in the opacity rule. `FZF_DEFAULT_COMMAND` (set in `.bashrc`) excludes `.git`, `node_modules`, `.cache`, `.npm`, `.cargo`, `.rustup`, `.keychain`, and `.local/share/containers` to keep results fast and relevant.
- Rofi (`Super + D`, bound in `hyprland.lua`) uses a dark floating-pill theme matching waybar/wlogout: `rgba(18,18,22,0.90)` background, thin white hairline border, 16px rounded corners, muted blue-grey highlight on the selected row instead of a bright accent color. `config.rasi` sets `modi` to `drun,run,window` and points at `theme.rasi` via `@theme`.
- Theme switching: a paintbrush icon sits leftmost in waybar's right-side module group. Clicking it runs `theme-menu`, which opens a small wlogout-based popup (same mechanism as `power-menu`) listing "Dark", "Rose", "Nokron" (violet/indigo with a warm gold accent, inspired by a starry-ruins wallpaper), and "Krat" (steel-blue-grey base with teal and magenta accents, gothic-noir hotel wallpaper). Picking one runs `theme-switch <name>`, which copies that preset's 8 files (waybar, wlogout, rofi, hyprlock, alacritty, hyprpaper, the theme-switcher popup's own style, and mako's notification styling) into place, restarts waybar (`SIGUSR2`), hyprpaper, and reloads mako (`makoctl reload`), then fires a notification. Each preset's `action` in `theme-switcher/layout` wraps the command in `setsid sh -c '...'` — without `setsid`, wlogout kills the spawned process when its own window closes (which happens immediately after a click), so anything past the first couple of fast commands (like the `hyprctl hyprpaper` calls) would silently never run. Alacritty only picks up new colors on freshly-opened windows; already-open terminals need to be closed and reopened. The picker popup's own background/border themes along with everything else, but each button's *hover color* (blue for Dark, rose for Rose, violet for Nokron, teal for Krat) stays fixed across all four presets by design — it identifies which theme that button switches *to*, not the currently active one. The popup widened to `280px`/`-b 4` to fit the fourth button.
