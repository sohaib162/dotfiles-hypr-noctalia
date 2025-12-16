# Login shell config
export EDITOR=${EDITOR:-nvim}
export VISUAL=${VISUAL:-nvim}
export PAGER=${PAGER:-less}

# Fix common terminal annoyance (Ctrl+S freezing)
stty -ixon 2>/dev/null || true
