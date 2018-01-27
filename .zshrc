# Path to oh-my-zsh installation.
export ZSH=${HOME}/.oh-my-zsh
export ZSH_CUSTOM=$ZSH/custom

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
ZSH_THEME="agnoster"

# Add wisely, as too many plugins slow down shell startup.
plugins=(
	git 
	zsh-autosuggestions 
	zsh-syntax-highlighting
)

source ~/.oh-my-zsh/oh-my-zsh.sh
source ~/.alias

export PATH=~/.local/bin:$PATH
export VISUAL=vim
export EDITOR="$VISUAL"
xinput set-button-map 11 1 1 3
