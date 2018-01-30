# Setup fzf
# ---------
if [[ ! "$PATH" == */home/seth/.fzf/bin* ]]; then
  export PATH="$PATH:/home/seth/.fzf/bin"
fi

# Auto-completion
# ---------------
[[ $- == *i* ]] && source "/home/seth/.fzf/shell/completion.zsh" 2> /dev/null

# Key bindings
# ------------
source "/home/seth/.fzf/shell/key-bindings.zsh"

