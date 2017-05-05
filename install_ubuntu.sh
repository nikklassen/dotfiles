#!/bin/zsh

sudo add-apt-repository ppa:neovim-ppa/stable
sudo apt-get update

while read -r line; do
    sudo apt-get install -yq "$line"
done < ubuntu_packages.txt

