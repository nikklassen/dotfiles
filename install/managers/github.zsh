#!/bin/zsh

(( _DOTFILES_INSTALL_MANAGERS_GITHUB_SH++ != 0 )) && return

function github::install() {
  ir config --path ~/.local/bin
  pkgs=(
    asdf-vm/asdf
    dandavison/delta
    golangci/golangci-lint
    junegunn/fzf
  )
  for pkg in $pkgs; do
    ir get -y "https://github.com/$pkg"
  done
}

# @param repo The repository to check
# @param version The current version. If empty then the latest version will be returned.
# @prints The latest version, or nothing if the repo is already up to date.
function github::latest_tag() {
  local repo="$1"
  local current_version="$2"
  local latest_version="$(
    git ls-remote --tags --sort -version:refname "${repo}" | \
      head -1 | \
      sed -n -E 's!.*refs/tags/(v?([0-9]+\.)*[0-9]+).*!\1!p'
  )"
  if [[ -z $latest_version ]]; then
     echo "No version tags found for repository ${repo?}" >&2
    return 1
  fi
  if [[ "${current_version?}" == "${latest_version?}" ]]; then
    return
  fi
  echo "${latest_version?}"
}
