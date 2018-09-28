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
  #ZSH_THEME="robbyrussel"
else
  ZSH_THEME="agnoster"
fi

# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git 
	zsh-autosuggestions 
	zsh-syntax-highlighting
	sudo
    zsh-autopair
)

source $ZSH/oh-my-zsh.sh
source ~/.alias
source ~/.path


# Launch tmux on start. Uncomment the end to attach on start.
if [[ $DISPLAY || $XDG_VTNR -ne 1 ]]; then
	[[ "${TERM}" != *"screen"* ]] && exec tmux new-session  #-A -s 0
fi

if [[ -x "$(command -v fzf)" ]]; then
	[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
fi

zstyle ':completion:*:*:nvim:*:*files' ignored-patterns '*.pdf'
zstyle ':completion:*:*:nvim:*:*files' ignored-patterns '*.o'
