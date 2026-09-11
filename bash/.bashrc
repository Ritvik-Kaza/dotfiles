#
# ~/.bashrc
#

# If not running interactively, don't do anything

source /usr/share/git/completion/git-prompt.sh

GIT_PS1_SHOWDIRTYSTATE=1

set_prompt() {
    local exit_code=$?
    local RED="\[\033[0;31m\]"
    local BLUE="\[\033[0;34m\]"
    local CYAN="\[\033[0;36m\]"
    local DARKBLUE="\[\033[0;34m\]"
    local DARKRED="\[\033[0;31m\]"
    local YELLOW="\[\033[0;33m\]"
    local RESET="\[\033[0m\]"

    local branch
    branch=$(git symbolic-ref --short HEAD 2>/dev/null)

    if [[ -z "$branch" ]] && git rev-parse --git-dir >/dev/null 2>&1; then
        local short_hash
        short_hash=$(git rev-parse --short HEAD 2>/dev/null)
        [[ -n "$short_hash" ]] && branch="(${short_hash})"
    fi

    if [[ -n "$branch" ]]; then
        PS1="${CYAN}\W${RESET}"
        PS1+=" ${DARKBLUE}git:(${DARKRED}${branch}${DARKBLUE})${RESET}"
        [[ -n "$(git status --porcelain 2>/dev/null)" ]] && PS1+=" ${YELLOW}✗${RESET}"
    else
        PS1="${BLUE}\u${RESET}@${RED}\h${RESET} ${CYAN}\w${RESET}"
    fi

    PS1+="⛏ "
}

PROMPT_COMMAND=set_prompt

alias suspend='hyprlock >/dev/null 2>&1 & sleep 1 && systemctl suspend >/dev/null 2>&1'

eval $(keychain --eval id_ed25519)

eval "$(fzf --bash)"

export FZF_DEFAULT_COMMAND='fd --type f --strip-cwd-prefix --hidden --follow \
  --exclude .git --exclude node_modules --exclude .cache --exclude .npm \
  --exclude .cargo --exclude .rustup --exclude .keychain \
  --exclude .local/share/containers'
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
