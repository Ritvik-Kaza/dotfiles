#!/usr/bin/env bash
SESSION="coding"

if tmux has-session -t "$SESSION" 2>/dev/null; then
    alacritty -e tmux attach-session -t "$SESSION"
else
    tmux new-session -d -s "$SESSION" -n editor "nvim ."
    tmux new-window -t "$SESSION" -n shell
    tmux select-window -t "$SESSION:1"
    alacritty -e tmux attach-session -t "$SESSION"
fi
