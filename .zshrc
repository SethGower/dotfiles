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
source ~/.path


# Launch tmux on start. Uncomment the end to attach on start.
[[ "${TERM}" != *"screen"* ]] && exec tmux new-session # -A -s 0

if [[ -x "$(command -v "X")" ]]; then
	xinput set-button-map 11 1 1 3
fi
