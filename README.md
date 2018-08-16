# Seth Gower's dotfiles

### Installation

I use [GNU Stow](https://www.gnu.org/software/stow/) to install and link my dotfiles. 


All you need to do is simply clone this repo (I suggest into `~/.dotfiles`). Because I have some git submodules for `zsh` and `oh-my-zsh`, you need to add the `--recursive` option to the `clone` call. An example of that is below:

```sh
git clone --recursive git@gitlab.com:SethGower/dotfiles.git $HOME/.dotfile
git submodule update --init --recursive --remote # update to the most recent commit on the remote branch of the submodules
```

```sh
stow i3 polybar vim
```

Or you can use any of the other package folder in this repo. 
