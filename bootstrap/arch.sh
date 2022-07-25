#!/usr/bin/env bash
cd $SCRIPT_DIR
source ./arch-functions.sh

#install_pkg polybar neovim alacritty dunst git \
#            i3-gaps ranger redshift rofi tmux zsh \
#            xfce4 xfce4-goodies

if [[ ! -d ~/.local/share/nvim/site/pack/packer/start/packer.nvim ]]
then
  git clone https://github.com/wbthomason/packer.nvim\
      ~/.local/share/nvim/site/pack/packer/start/packer.nvim
fi
