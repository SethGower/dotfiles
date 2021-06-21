#!/usr/bin/env bash

if [[ -z $@ ]]; then
  >&2 echo "Usage Error! Please provide modules to install"
  >&2 echo "Example: ./$0 i3 polybar xorg neovim"
  exit 1
fi

export OS=$(cat /etc/os-release | grep -E "\bID\b" | cut -d'=' -f2)
if [[ $OS == "arch" ]];
then
  export AUR_HELPER="paru"
fi

for package in $@
do
  # adds safeguard (not super necessary) to only run install script if it exists
  if [[ -f ./install.d/${OS}/${package}.sh ]];
  then
    ./install.d/${OS}/$package.sh
  fi
  stow $package
done
