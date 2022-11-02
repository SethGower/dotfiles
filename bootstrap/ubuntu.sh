#!/usr/bin/bash

sudo apt-get install software-properties-common
sudo add-apt-repository ppa:neovim-ppa/unstable

snap list | grep firefox &> /dev/null
echo "Snap has firefox, need to remove firefox from snap then install from apt"
if [ $? = 0]
then
  sudo add-apt-repository ppa:mozillateam/ppa
  echo '
  Package: *
  Pin: release o=LP-PPA-mozillateam
  Pin-Priority: 1001
  ' | sudo tee /etc/apt/preferences.d/mozilla-firefox
  
  echo 'Unattended-Upgrade::Allowed-Origins:: "LP-PPA-mozillateam:${distro_codename}";' | sudo tee /etc/apt/apt.conf.d/51unattended-upgrades-firefox
  sudo snap remove firefox
fi

sudo apt-get update
sudo apt-get install neovim firefox git python3 python3-pip
