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

# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git
	zsh-autosuggestions
	zsh-syntax-highlighting
	sudo
    zsh-autopair
)
ZSH_DISABLE_COMPFIX=true
source $ZSH/oh-my-zsh.sh
source ~/.function
source ~/.alias
source ~/.path

if [ -f ~/.profile ]; then
    source ~/.profile
fi

compinit

# Launch tmux on start. Uncomment the end to attach on start.
# if [[ $DISPLAY || $XDG_VTNR -ne 1 ]]; then
# 	[[ "${TERM}" != *"screen"* ]] && exec tmux new-session  #-A -s 0
# fi

if [[ -f ~/.fzf.zsh ]];
then
    source ~/.fzf.zsh
    export FZF_DEFAULT_OPTS="--preview='bat --color=always {}'"
fi

zstyle ':completion:*:*:nvim:*' file-patterns '^*.(aux|log|pdf|dvi|o):source-files' '*:all-files'

if [[ -x "$(command -v starship)" ]]; then
    eval "$(starship init zsh)"
fi
