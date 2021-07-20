# Seth Gower's dotfiles

### Installation

I use [YADM](https://yadm.io) manage my dotfiles.



All you need to do is simply clone this repo (I suggest into `~/.dotfiles`). Because I have some git submodules for `zsh` and `oh-my-zsh`, you need to add the `--recursive` option to the `clone` call. An example of that is below:

```sh
$ yadm clone https://github.com/SethGower/dotfiles.git
$ yadm status
$ yadm submodule init
$ yadm submodule update
```

#### Note on Stow
If you are looking for when I used [GNU Stow](https://www.gnu.org/software/stow/) checkout [v1.0](https://github.com/SethGower/dotfiles/releases/tag/v1.0)

Instructions to clone that are:
```
$ git clone https://github.com/SethGower/dotfiles.git --recursive -b v1.0 $HOME/.dotfiles
$ cd $HOME/.dotfiles
$ stow <package_name>
```
### License

This software is freely distributed under the terms of the [MIT License](https://opensource.org/licenses/MIT)
