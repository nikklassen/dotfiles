#!/bin/zsh

sudo add-apt-repository ppa:neovim-ppa/stable
# This does apt-get update as well
curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -

while read -r line; do
    sudo apt-get install -yq "$line"
done < ubuntu_packages.txt

