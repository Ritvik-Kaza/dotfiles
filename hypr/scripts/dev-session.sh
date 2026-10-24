#!/usr/bin/env bash
SESSION="coding"

if tmux has-session -t "$SESSION" 2>/dev/null; then
    alacritty -e tmux attach-session -t "$SESSION"
else
    # nvim is typed into a shell rather than being the window's own command,
    # so :q drops back to that shell instead of closing the window. Going
    # through the shell also picks up .bashrc's nvim() wrapper (--listen
    # socket for theme-switch), same as launching nvim by hand.
    tmux new-session -d -s "$SESSION" -n editor
    tmux send-keys -t "$SESSION:editor" 'nvim .' Enter
    tmux new-window -t "$SESSION" -n shell
    tmux select-window -t "$SESSION:1"
    alacritty -e tmux attach-session -t "$SESSION"
fi
