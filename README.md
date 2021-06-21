# Seth Gower's dotfiles

### Installation

I use [GNU Stow](https://www.gnu.org/software/stow/) to install and link my dotfiles. 


All you need to do is simply clone this repo (I suggest into `~/.dotfiles`). Because I have some git submodules for `zsh` and `oh-my-zsh`, you need to add the `--recursive` option to the `clone` call. An example of that is below:

```sh
$ git clone --recursive https://github.com/SethGower/dotfiles.git $HOME/.dotfiles #clones repo and submodules to $HOME/.dotfiles
$ cd $HOME/.dotfiles
$ git submodule update --init --recursive --remote # update to the most recent commit on the remote branch of the submodules

# Installs the config files (but doesn't install programs)
$ stow i3 polybar vim # installs the contents of the i3 polybar and vim directories to the parent dir ($HOME/)

# Installs programs and the config files
$ ./install.sh i3 polybar vim # see ./install.d/README.md
```

Or you can use any of the other package folder in this repo. 

### Usage

#### Branching

I have started using branches to differentiate between different versions of
my dotfiles. The current version that I am using will be stored in master as
well as its named branch. Other versions are stored in other branches. Current
branches are 

- alpha (newest)
- beta (first rice. Naming is reversed because of creation of branches and
  stuff)

### License

This software is freely distributed under the terms of the [MIT License](https://opensource.org/licenses/MIT)
