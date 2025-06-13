#!/bin/bash

function install() {
  sudo apt-get update
  sudo apt-get install -yq apt-transport-https ca-certificates gnupg curl
  local key_file="/usr/share/keyrings/cloud.google.gpg"
  sudo rm -rf "$key_file"
  curl https://packages.cloud.google.com/apt/doc/apt-key.gpg | \
    sudo gpg --dearmor -o "$key_file"
  echo "deb [signed-by=${key_file}] https://packages.cloud.google.com/apt cloud-sdk main" | \
    sudo tee /etc/apt/sources.list.d/google-cloud-sdk.list
  sudo apt-get update && sudo apt-get install -yq google-cloud-cli
}
