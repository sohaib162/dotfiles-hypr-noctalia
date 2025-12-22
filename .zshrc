# -------------------------------
# ZSH (zinit + starship) config
# -------------------------------

# Stop the new-user wizard forever
zmodload zsh/zle

# History
HISTFILE="$HOME/.zsh_history"
HISTSIZE=50000
SAVEHIST=50000
setopt HIST_IGNORE_ALL_DUPS HIST_SAVE_NO_DUPS HIST_REDUCE_BLANKS SHARE_HISTORY
setopt APPEND_HISTORY INC_APPEND_HISTORY
setopt EXTENDED_GLOB AUTO_CD CORRECT

# Completion (fast + cached)
autoload -Uz compinit
mkdir -p ~/.cache/zsh
compinit -d ~/.cache/zsh/zcompdump

# Completion style
zstyle ':completion:*' menu select
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|[._-]=* r:|=*'
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' rehash true

# Keybindings
bindkey -e
bindkey '^[[H' beginning-of-line   # Home
bindkey '^[[F' end-of-line         # End

# Better defaults
setopt NO_BEEP
unsetopt FLOW_CONTROL

# Aliases (modern replacements)
command -v eza >/dev/null && alias ls='eza --group-directories-first --icons' || alias ls='ls --color=auto'
command -v eza >/dev/null && alias ll='eza -lah --group-directories-first --icons' || alias ll='ls -lah --color=auto'
command -v bat >/dev/null && alias cat='bat -pp' || true
alias grep='grep --color=auto'
alias ..='cd ..'
alias ...='cd ../..'
alias cl='clear'
alias fyp='conda activate fyp'
alias gpu='watch -n 1 -d nvidia-smi'
alias hyprconf='nano .config/hypr/hyprland.conf'

# Coding aliases
alias gl='git log --oneline --graph --decorate'
alias gs='git status'
alias ga='git add'
alias gc='git commit'
alias gp='git push'
alias py='python'
alias pip='python -m pip'
alias venv='python -m venv'
alias act='source venv/bin/activate'
alias dev='npm run dev'
alias build='npm run build'
alias test='npm test'

# Function to cd to project
function proj() {
  cd ~/Projects/$1
}

# Useful functions
mkcd() { mkdir -p "$1" && cd "$1"; }

extract() {
  if [ -f "$1" ]; then
    case "$1" in
      *.tar.bz2) tar xjf "$1" ;;
      *.tar.gz)  tar xzf "$1" ;;
      *.bz2)     bunzip2 "$1" ;;
      *.rar)     unrar x "$1" ;;
      *.gz)      gunzip "$1" ;;
      *.tar)     tar xf "$1" ;;
      *.tbz2)    tar xjf "$1" ;;
      *.tgz)     tar xzf "$1" ;;
      *.zip)     unzip "$1" ;;
      *.7z)      7z x "$1" ;;
      *) echo "extract: don't know how to extract '$1'" ;;
    esac
  else
    echo "extract: '$1' is not a file"
  fi
}

# zoxide (smart cd)
command -v zoxide >/dev/null && eval "$(zoxide init zsh)"

# Auto activate venv on cd
function chpwd() {
  if [[ -d ".venv" ]]; then
    source .venv/bin/activate
  fi
}

# starship prompt
command -v starship >/dev/null && eval "$(starship init zsh)"

# fzf keybinds (Ctrl+R history search, etc.) if installed
if [ -f /usr/share/fzf/shell/key-bindings.zsh ]; then
  source /usr/share/fzf/shell/key-bindings.zsh
fi
if [ -f /usr/share/fzf/shell/completion.zsh ]; then
  source /usr/share/fzf/shell/completion.zsh
fi

# -------------------------------
# zinit (plugin manager)
# -------------------------------
ZINIT_HOME="${XDG_DATA_HOME:-$HOME/.local/share}/zinit/zinit.git"
if [ ! -d "$ZINIT_HOME" ]; then
  mkdir -p "$(dirname "$ZINIT_HOME")"
  git clone https://github.com/zdharma-continuum/zinit.git "$ZINIT_HOME"
fi
source "$ZINIT_HOME/zinit.zsh"

# Plugins (order matters: syntax-highlighting last)
zinit light zsh-users/zsh-autosuggestions
zinit light zdharma-continuum/fast-syntax-highlighting
zinit light zsh-users/zsh-completions

# Optional: nicer tab completion menu
zinit light Aloxaf/fzf-tab

# Make autosuggestions accept with Right Arrow (and keep normal behavior)
ZSH_AUTOSUGGEST_ACCEPT_WIDGETS+=(end-of-line forward-char)

# Nice: show fastfetch on new terminal (comment if you dislike it)
#command -v fastfetch >/dev/null && fastfetch
PROMPT=$'%~\n⚡ '

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/sohaib/miniconda3/bin/conda' 'shell.zsh' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/sohaib/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/sohaib/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/sohaib/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<

