# dotfiles

Personal configuration files for my Arch Linux + Hyprland setup.

## Structure

```
dotfiles/
├── alacritty/
│   └── alacritty.toml     # Base terminal config: dark theme colors, opacity, font
├── bash/
│   └── .bashrc          # Custom prompt: git-aware, branch + dirty state indicator; wraps nvim to always listen on a socket
├── nvim/
│   └── init.lua          # Kickstart-based config; tokyonight recolored per active theme, live-switchable
├── hypr/
│   ├── hyprland.lua      # Main Hyprland config (Lua-based, Hyprland 0.55+)
│   ├── hyprlock.conf     # Lock screen config
│   ├── hyprpaper.conf    # Wallpaper config
│   ├── hypridle.conf     # Idle daemon: lock at 10min, suspend at 30min
│   └── scripts/
│       ├── dev-session.sh          # Opens Alacritty + tmux with nvim in one window, shell in another
│       ├── power-menu              # Anchors a wlogout popup under the waybar power icon
│       ├── theme-switch            # Copies a theme preset's files into place, reloads waybar/hyprpaper
│       ├── theme-menu              # Anchors the theme-picker wlogout popup under the waybar theme icon
│       ├── hyprpaper-init          # Starts hyprpaper and explicitly re-applies wallpaper via hyprctl (fixes wallpaper not loading on boot)
│       ├── webapp-install          # Turns any website into a chromeless launcher app (chromium --app) with a fetched favicon
│       ├── find-text               # Fuzzy-finds a file by content instead of name (plain text via ripgrep, or all file types via ripgrep-all)
│       ├── fullscreen-aware-focus  # Directional focus switch that preserves fullscreen/maximize state across the switch
│       └── screenshots/
│           ├── captureArea.sh
│           ├── captureScreen.sh
│           └── captureText.sh      # Region-select OCR via tesseract, copies extracted text to clipboard
├── tmux/
│   └── .tmux.conf        # tmux config: custom prefix, mouse support, Alt+number window switching
├── rofi/
│   ├── config.rasi        # Rofi config: drun mode, icons, font
│   └── theme.rasi          # Dark floating-pill theme matching waybar/wlogout
├── theme-presets/
│   ├── dark/              # Neutral dark theme: 8 files — waybar/wlogout/rofi/hyprlock/alacritty/hyprpaper/theme-switcher/mako
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
    ├── layout             # Lock / suspend / reboot / shutdown buttons
    └── style.css          # Floating dark-pill styling to match waybar
```

## Dependencies

Everything below is for Arch Linux (`pacman`/AUR). Install what corresponds to the configs you're actually using.

**Core (used by more than one config, or required for the setup to function at all):**
```bash
sudo pacman -S hyprland waybar alacritty tmux neovim git \
               ttf-cascadia-mono-nerd fzf fd bat ripgrep
yay -S ripgrep-all
```
- `fzf` / `fd` / `bat`: fuzzy file finder used from Bash (Ctrl+T / Alt+C) and by the Super+F floating popup below.
- `ripgrep`: powers the Super+Shift+F content-search popup (text files only, fast).
- `ripgrep-all` (AUR): powers the Super+Alt+F content-search popup — also searches PDFs, Office docs, archives, and images (via OCR), at the cost of being slower since it has to extract each file's text before searching it.
- `xdg-utils`: `find-text` hands off any non-text result (a PDF, a `.docx`) to `xdg-open` rather than forcing it into `nvim` — opens with whatever's registered as the default handler for that file type (e.g. Papers for PDFs). Likely already installed as a dependency of other packages, but not guaranteed on a minimal install.

**hypr/**
```bash
sudo pacman -S hyprlock hyprpaper grim slurp wl-clipboard jq hypridle cliphist polkit-gnome tesseract tesseract-data-eng
```
- `grim` + `slurp`: used by `hypr/scripts/screenshots/captureArea.sh`, `captureScreen.sh`, and `captureText.sh`.
- `tesseract` + `tesseract-data-eng`: OCR engine used by `captureText.sh` (`Super + Alt + S`) to read text out of a selected screen region. Swap `tesseract-data-eng` for a different `tesseract-data-*` package if you need another language.
- `jq`: used by `hypr/scripts/power-menu` and `theme-menu` to read monitor geometry from `hyprctl`, and by `fullscreen-aware-focus` to read the focused window's fullscreen state.
- `hypridle`: auto-locks after 10 minutes idle, suspends after 30 (`hypridle.conf`). Autostarted in `hyprland.lua`.
- `cliphist`: clipboard history, bound to `Super + V`, piped through the themed rofi menu. Needs a `wl-paste --watch cliphist store` autostart line alongside it (also in `hyprland.lua`).
- `polkit-gnome`: GUI privilege-escalation prompts for apps that need root outside a terminal. Autostarted in `hyprland.lua`.
- `chromium` (optional): only needed for `webapp-install`, which turns any website into a chromeless launcher app. `intel-media-driver` is also needed for hardware video decode (VAAPI) to work correctly in these webapp windows.
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
- **Duplication risk, not a bug:** `waybar/style.css`, `wlogout/style.css`, `theme-switcher/style.css`, `rofi/theme.rasi`, and `alacritty/alacritty.toml` at the top level are meant to mirror whichever preset they were last synced from, and `theme-switch <name>` overwrites these same paths with that preset's files. Editing one of them directly without updating the matching preset means a future `theme-switch <name>` on that theme will silently revert the edit — after tweaking colors directly, either update the matching preset file too or just re-run `theme-switch <name>` to resync.
- **Top-level files currently reflect `krat`, not `dark`:** `waybar/style.css`, `wlogout/style.css`, `theme-switcher/style.css`, and `alacritty/alacritty.toml` at the top level currently hold `theme-presets/krat/`'s colors (from an earlier sync off a live machine that had krat active), while `hypr/hyprlock.conf` and `hypr/hyprpaper.conf` at the top level still point at `wallpaper2.png` (dark's wallpaper) — a mixed state, left as-is intentionally as the starting point for a fresh install rather than reconciled back to dark. `rofi/theme.rasi` is unaffected since it isn't themed per-preset. If you clone this repo fresh, run `theme-switch <name>` for whichever theme you actually want right after copying files — don't assume the top-level copy alone gives a fully consistent look.

## Usage

These are plain copies, not symlinked. To apply a config, copy the relevant file(s) into place manually:

```bash
cp bash/.bashrc ~/.bashrc
cp nvim/init.lua ~/.config/nvim/init.lua
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
cp hypr/scripts/hyprpaper-init ~/.local/bin/hyprpaper-init
cp hypr/scripts/webapp-install ~/.local/bin/webapp-install
chmod +x ~/.local/bin/power-menu ~/.local/bin/theme-switch ~/.local/bin/theme-menu ~/.local/bin/hyprpaper-init ~/.local/bin/webapp-install ~/.config/hypr/scripts/*.sh
```

Reload as needed (`source ~/.bashrc`, `tmux source-file ~/.tmux.conf`, restart Hyprland/Waybar).

## Notes

- Bash prompt shows `user@host path` outside git repos, and `dirname git:(branch)` (with a `✗` for uncommitted changes) inside git repos.
- Hyprland config uses the newer Lua-based format (`hyprland.lua`), not the legacy `hyprland.conf`.
- `mainMod + N` in Hyprland runs `dev-session.sh`, opening Alacritty with a tmux session: window 1 = `nvim .`, window 2 = plain shell, focused on window 1.
- tmux prefix is `Ctrl+A` (remapped from default `Ctrl+B`). Windows can also be switched directly with `Alt+1` through `Alt+9`, no prefix needed, and 'Alt + Tab' can be used to switch to the previous window.
- Waybar is styled as individually floating, semi-transparent pills rather than one solid bar; pairs with the `blur` layer rules in `hyprland.lua` for the waybar and wlogout namespaces.
- Clicking the power icon in waybar runs `power-menu`, which opens a small wlogout popup (lock / suspend / reboot / shutdown) anchored under the icon instead of a fullscreen menu. Requires `wlogout` and `jq`.
- `hyprlock.conf` is a minimal centered theme: large clock, date, greeting, and a translucent password pill, all vertically centered; battery percentage sits small in the top-right corner. Background is the normal wallpaper blurred at lock time via hyprlock's own `blur_passes`/`blur_size`, not a separate pre-blurred image. The password field's outline turns amber (`capslock_color`) when caps lock is on. Battery path assumes `BAT0` — check `/sys/class/power_supply/` if yours differs.
- `Super + F` opens a small floating Alacritty window running `fzf` piped into `nvim`, for fuzzy-finding and opening any file under `$HOME` by its **name**. Floating, resizing (560×320), and centering are handled by a `window.open` event handler in `hyprland.lua`, not a static window rule — the popup gets its own opacity override too, applied via a widened `Alacritty|alacritty-fzf` regex in the opacity rule. `FZF_DEFAULT_COMMAND` (set in `.bashrc`) excludes `.git`, `node_modules`, `.cache`, `.npm`, `.cargo`, `.rustup`, `.keychain`, and `.local/share/containers` to keep results fast and relevant.
- **Content search** (`hypr/scripts/find-text`) finds a file by the text **inside** it instead of its name — same floating-popup mechanism as `Super + F` above, reusing the same window rule. `Super + Shift + F` searches plain text files only, via `ripgrep`, live-updating as you type; `Super + Alt + F` searches everything (PDFs, Office docs, archives, images via OCR) via `ripgrep-all`, at the cost of speed, since each file's text has to be extracted before it can be searched. Either way the result list is filenames, never the matched text itself — picking one opens it. Text files open in `nvim`; anything `nvim` can't meaningfully display (a PDF, a `.docx`) is handed to `xdg-open` instead, detached with `setsid`/`disown` plus a short `sleep` so the popup's terminal can close without killing whatever it just launched — the sleep is load-bearing, not padding, since there's a narrow window right after forking where the child can still get killed by the terminal closing before the detach fully lands.
- Rofi (`Super + D`, bound in `hyprland.lua`) uses a dark floating-pill theme matching waybar/wlogout: `rgba(18,18,22,0.90)` background, thin white hairline border, 16px rounded corners, muted blue-grey highlight on the selected row instead of a bright accent color. `config.rasi` sets `modi` to `drun,run,window` and points at `theme.rasi` via `@theme`.
- **Wallpaper not loading on boot:** `hyprpaper`'s own `wallpaper =` config directive doesn't reliably apply at its own startup on this system — only the live `hyprctl hyprpaper wallpaper ...` IPC command actually works. `hypr/scripts/hyprpaper-init` works around this: it starts hyprpaper, waits for its IPC socket to come up, then explicitly re-sends the wallpaper command by reading the path out of `hyprpaper.conf`. `hyprland.lua`'s autostart calls this script instead of `hyprpaper` directly.
- `Super + V` opens clipboard history (cliphist piped through the themed rofi menu). The cliphist bind guards against Esc/empty selection — piping an empty rofi result straight into `wl-copy` would silently blank the clipboard, so the script checks for a non-empty selection before copying.
- **Screenshots**: `Print` (`captureScreen.sh`) grabs the active monitor instantly; `Super + Shift + S` (`captureArea.sh`) opens `slurp` for an interactive region select and copies the image; `Super + Alt + S` (`captureText.sh`) does the same region select but OCRs it via `tesseract` and copies the extracted text instead.
- `Super + Left/Right/Up/Down` (directional focus) runs `fullscreen-aware-focus <direction>` instead of calling the focus dispatcher directly: it reads the focused window's fullscreen state via `hyprctl activewindow -j`, and if it's fullscreen or maximized, un-fullscreens, switches focus, then re-applies the same mode to the newly focused window — so fullscreening a window (`Super + Shift + Space`) and then switching focus keeps the next window fullscreen too, instead of dropping back to the tiled view. The JSON state Hyprland reports (`1` = maximize, `2` = fullscreen) doesn't match the fullscreen dispatcher's own `mode` argument (`0` = fullscreen, `1` = maximize), so the script translates between the two.
- Theme switching: a paintbrush icon sits leftmost in waybar's right-side module group. Clicking it runs `theme-menu`, which opens a small wlogout-based popup (same mechanism as `power-menu`) listing "Dark", "Rose", "Nokron" (violet/indigo with a warm gold accent, inspired by a starry-ruins wallpaper), and "Krat" (steel-blue-grey base with teal and magenta accents, gothic-noir hotel wallpaper). Picking one runs `theme-switch <name>`, which copies that preset's 8 files (waybar, wlogout, rofi, hyprlock, alacritty, hyprpaper, the theme-switcher popup's own style, and mako's notification styling) into place, restarts waybar (`SIGUSR2`), hyprpaper, and reloads mako (`makoctl reload`), then fires a notification. Each preset's `action` in `theme-switcher/layout` wraps the command in `setsid sh -c '...'` — without `setsid`, wlogout kills the spawned process when its own window closes (which happens immediately after a click), so anything past the first couple of fast commands (like the `hyprctl hyprpaper` calls) would silently never run. Alacritty only picks up new colors on freshly-opened windows; already-open terminals need to be closed and reopened. The picker popup's own background/border themes along with everything else, but each button's *hover color* (blue for Dark, rose for Rose, violet for Nokron, teal for Krat) stays fixed across all four presets by design — it identifies which theme that button switches *to*, not the currently active one. The popup widened to `280px`/`-b 4` to fit the fourth button.
- **Nvim theming**: `init.lua` keeps `tokyonight` as the colorscheme engine but overrides its background tones plus one accent hue (`blue`/`purple`/`cyan`) per active theme via `on_colors` — diagnostic colors (red/green/yellow for errors/warnings/hints) are deliberately left untouched so syntax highlighting stays legible. This is exposed as a global `ThemeApply(name)` function. `.bashrc` wraps `nvim` in a shell function that always launches it with `--listen /tmp/nvim-sockets/$$.sock`, giving every instance an RPC socket. `theme-switch` writes the active theme name to `~/.config/theme-current` (read by `init.lua` on startup) and loops over every live socket in `/tmp/nvim-sockets/`, running `nvim --server <sock> --remote-expr "v:lua.ThemeApply('<name>')"` so **already-open** nvim windows recolor live, not just freshly-launched ones — the one case in this setup where a "reopen to see new colors" limitation (like Alacritty's) is avoidable. The broadcast loop's `nvim --server` call is suffixed with `|| true`, since `theme-switch` runs under `set -euo pipefail` and a stale/dead socket failing there would otherwise abort the entire script before it reaches the waybar/hyprpaper reload steps. `dev-session.sh`'s tmux-launched nvim (`tmux new-session ... "nvim ."`) runs as tmux's literal pane command, bypassing the `.bashrc` shell function entirely, so it's given its own explicit `--listen /tmp/nvim-sockets/dev-session.sock` directly in the script instead of relying on the wrapper.
- **Alacritty `opacity = 1.0` on purpose:** Alacritty's own internal `opacity` setting, when less than 1.0, interacts badly with nvim's explicitly-painted background colors — cells nvim paints with an explicit true-color background render differently than the terminal's own idle/padding background, producing a visible seam ("double layer" look) around nvim's content specifically. Transparency itself isn't lost: a separate Hyprland `windowrule` (`opacity = "0.80 override 0.80 override"`, matching `^(Alacritty|alacritty-fzf)$`) provides the wallpaper-through-terminal look at the compositor level instead, which blends the whole rendered window uniformly and doesn't have this issue. Don't lower Alacritty's own `opacity` back down to "fix" transparency — it'll reintroduce the seam; adjust the Hyprland windowrule's opacity value instead if more/less transparency is wanted.
- **`webapp-install <Name> <url>`** turns any website into a chromeless launcher app: creates a `.desktop` entry running `chromium --app=<url> --class=<Name>`, fetches a real favicon via Google's favicon service and installs it into `~/.local/share/icons/hicolor/128x128/apps/` (falls back to a generic icon if the fetch fails), and gives the window a predictable class for Hyprland window rules. The generated `.desktop` file and icon are per-machine artifacts, not tracked in this repo — re-run the script on any new machine.
