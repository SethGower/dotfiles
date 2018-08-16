# Path to oh-my-zsh installation.
export ZSH=${HOME}/.config/zsh/oh-my-zsh
export ZSH_CUSTOM=$HOME/.config/zsh/.custom_omz

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git 
	zsh-autosuggestions 
	zsh-syntax-highlighting
	sudo
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

eval $(thefuck --alias)
eval $(thefuck --alias heck)
