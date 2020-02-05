# If wal is installed, use it
[[ -x $(command -v wal) ]] &&(cat ~/.cache/wal/sequences &)
# Path to oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh
export ZSH_CUSTOM=$HOME/.custom_omz

if [ -n "$SSH_CLIENT" ] || [ -n "$SSH_TTY" ]; then
  SESSION_TYPE=remote/ssh
else
  case $(ps -o comm= -p $PPID) in
    sshd|*/sshd) SESSION_TYPE=remote/ssh;;
  esac
fi
# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
if [ -n "$SESSION_TYPE" ]; then
  ZSH_THEME="robbyrussel"
else
  ZSH_THEME="candy"
fi

# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git 
	zsh-autosuggestions 
	zsh-syntax-highlighting
	sudo
    zsh-autopair
#    vi-mode
)
ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh
source ~/.alias
source ~/.path
source ~/.function

if [ -f ~/.local_conf ]; then
    source ~/.local_conf
fi

compinit

# Launch tmux on start. Uncomment the end to attach on start.
if [[ $DISPLAY || $XDG_VTNR -ne 1 ]]; then
	[[ "${TERM}" != *"screen"* ]] && exec tmux new-session  #-A -s 0
fi

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

zstyle ':completion:*:*:nvim:*' file-patterns '^*.(aux|log|pdf|dvi|o):source-files' '*:all-files'
