#!/bin/zsh

function install() {
  sudo add-apt-repository ppa:wslutilities/wslu
  sudo apt update
  sudo apt upgrade
}
