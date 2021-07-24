#!/usr/bin/env bash
source ./arch-functions.sh

install_pkg polybar neovim-nightly-bin alacritty compton-tryone-git dunst git \
            i3-gaps ranger redshift rofi tmux zsh 

if [[ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]]
then
  git clone https://github.com/wbthomason/packer.nvim\
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi
