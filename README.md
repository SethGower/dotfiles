# Seth Gower's dotfiles

### Installation

I use [DotBot](https://github.com/anishathalye/dotbot) manage my dotfiles.

All you need to do is simply clone this repo (I suggest into `~/.dotfiles`). Because I have some git submodules for
`zsh` and `oh-my-zsh`, you need to add the `--recursive` option to the `clone` call. An example of that is below:

```sh
$ git clone https://github.com/SethGower/dotfiles.git --recursive $HOME/.dotfiles # or wherever you want it
$ ./install # that's it
```

Bootstrapping is available for Arch Based distributions. Requires `pacman` and an [AUR
Helper](https://wiki.archlinux.org/title/AUR_helpers), I use [`paru`](https://aur.archlinux.org/packages/paru/), as set
in `./bootstrap/bootstrap` with the environment variable `AUR_HELPER`. To run the bootstrapping process, either
explicitly run the `bootstrap` script, just run `./install` normally (it'll install symlinks, along with run the
script), or finally you can run `./install --only shell` to only run the `shell` section

#### Note on Stow
If you are looking for when I used [GNU Stow](https://www.gnu.org/software/stow/) checkout
[v1.0](https://github.com/SethGower/dotfiles/releases/tag/v1.0)

Instructions to clone that are:
```sh
$ git clone https://github.com/SethGower/dotfiles.git --recursive -b v1.0 $HOME/.dotfiles
$ cd $HOME/.dotfiles
$ stow <package_name>
```

### License

This software is freely distributed under the terms of the [MIT License](https://opensource.org/licenses/MIT)
