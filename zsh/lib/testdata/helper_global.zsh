#!/bin/zsh

function print_global() {
  echo "helper global"
}

import::global print_global
