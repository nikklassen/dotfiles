#!/bin/bash
main() {
  echo "Checking for asdf updates"
  ASDF_REPO="https://github.com/asdf-vm/asdf.git"
  local latest_version="$(
    git ls-remote --tags --sort -version:refname "${ASDF_REPO}" | \
      head -1 | \
      sed -E 's!.*refs/tags/(v([0-9]+\.)*[0-9]+).*!\1!'
  )"
  local current_version="$(asdf version 2> /dev/null)"
  if [[ "${current_version?}" == "${latest_version?}" ]]; then
    echo "Already up to date"
    return
  fi

  echo "New version: ${latest_version}"
  TMP="/tmp/asdf-${latest_version}-linux-amd64.tar.gz"
  wget -O "$TMP" "https://github.com/asdf-vm/asdf/releases/download/${latest_version}/asdf-${latest_version}-linux-amd64.tar.gz"
  echo "Extracting to /usr/local/bin"
  sudo tar --extract --gunzip --directory=/usr/local/bin -f "$TMP"
  rm "$TMP"
}

main
