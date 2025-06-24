#!/bin/zsh

function install() {
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | \
    sh -s -- -y --no-modify-path --default-toolchain stable
  local crates=(
    cargo-binstall
    proximity-sort
  )
  for crate in $crates; do
    cargo install $crate
  done
  local binaries=(
    jj-cli
  )
  for binary in $binaries; do
    cargo binstall --strategies crate-meta-data $binary
  end
}
