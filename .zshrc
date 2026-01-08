# =====================================
# PATH Configuration
# =====================================
export PATH="$HOME/bin:$PATH"
export PATH="/usr/local/bin:/opt/homebrew/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# pnpm
export PNPM_HOME="/Users/daniel/Library/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac

# Bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"

# =====================================
# Editor
# =====================================
export EDITOR="cursor --wait"
export VISUAL="$EDITOR"

# =====================================
# Shell Options
# =====================================
setopt AUTO_CD              # cd by typing directory name
setopt NO_CASE_GLOB         # case insensitive globbing
setopt HIST_IGNORE_ALL_DUPS # remove older duplicate entries from history
setopt HIST_REDUCE_BLANKS   # remove superfluous blanks from history
setopt SHARE_HISTORY        # share history between sessions
setopt INC_APPEND_HISTORY   # append to history immediately
setopt EXTENDED_HISTORY     # add timestamps to history

# History Configuration
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000

# =====================================
# Colors
# =====================================
export CLICOLOR=1
export LSCOLORS=ExFxCxDxBxegedabagacad

# =====================================
# Keybindings
# =====================================
# Up/Down arrows: prefix history search
bindkey '^[[A' history-beginning-search-backward
bindkey '^[[B' history-beginning-search-forward
bindkey '\e[A' history-beginning-search-backward
bindkey '\e[B' history-beginning-search-forward

# Ctrl+R: incremental pattern search
bindkey '^R' history-incremental-pattern-search-backward

# Word navigation (Option+Left/Right)
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^[b' backward-word
bindkey '^[f' forward-word

# Delete word backward (Option+Delete)
bindkey '^[^?' backward-kill-word

# =====================================
# Aliases
# =====================================
# Modern replacements
alias ls="eza"
alias ll="eza -la --git"
alias la="eza -la"
alias tree="eza --tree"
alias cat="bat -p"

# Git
alias gs="git status"
alias ga="git add ."
alias gc="git commit -m"
alias gp="git push"
alias gpl="git pull"
alias gd="git diff"

# Navigation
alias ..="cd .."
alias ...="cd ../.."

# Other
alias claude-mem='$HOME/.bun/bin/bun "$HOME/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"'

# =====================================
# Git Prompt
# =====================================
autoload -Uz vcs_info

precmd() {
  vcs_info

  if [[ -n ${vcs_info_msg_0_} ]]; then
    # In a git repo: show path + branch
    PROMPT="%F{cyan}%~%f %F{yellow}(${vcs_info_msg_0_})%f"$'\n''› '
  else
    # Not in a git repo: only path
    PROMPT="%F{cyan}%~%f"$'\n''› '
  fi
}

zstyle ':vcs_info:*' enable git
zstyle ':vcs_info:git:*' formats '%b'

# =====================================
# Tool Initializations
# =====================================

# Zoxide (better cd)
if (( $+commands[zoxide] )); then
  eval "$(zoxide init zsh)"
fi

# FNM (Fast Node Manager)
FNM_PATH="/opt/homebrew/opt/fnm/bin"
if [ -d "$FNM_PATH" ]; then
  eval "`fnm env --use-on-cd`"
fi

# Node.js configuration
export NODE_OPTIONS="--max-old-space-size=4096"

# fzf (fuzzy finder)
if (( $+commands[fzf] )); then
  source <(fzf --zsh)
fi

# =====================================
# Completion System
# =====================================
# Docker CLI completions
fpath=(/Users/daniel/.docker/completions $fpath)

# Initialize completions (cached - rebuilds once per day)
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.mh+24) ]]; then
  compinit
else
  compinit -C
fi

# Completion styling
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}'  # Case-insensitive
zstyle ':completion:*' menu select                          # Menu selection
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}       # Colored completions
zstyle ':completion:*' special-dirs true                    # Complete . and ..
zstyle ':completion:*' group-name ''                        # Group by category
zstyle ':completion:*:descriptions' format '%F{yellow}-- %d --%f'

# =====================================
# One-time Setup
# =====================================
# Fix SSH permissions (only if needed)
if [ -d "$HOME/.ssh" ] && [ "$(stat -f '%A' ~/.ssh 2>/dev/null)" != "700" ]; then
  chmod 700 ~/.ssh
  chmod 600 ~/.ssh/* 2>/dev/null
fi

# =====================================
# Plugins (must be at the end)
# =====================================
# Autosuggestions (Fish-style suggestions from history)
source /opt/homebrew/share/zsh-autosuggestions/zsh-autosuggestions.zsh

# Syntax highlighting (must be last)
source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
