#!/bin/bash
ASDF_REPO="https://github.com/asdf-vm/asdf.git"
VERSION="$(
  git ls-remote --tags --sort -version:refname "${ASDF_REPO}" | \
    head -1 | \
    sed -E 's!.*refs/tags/(v([0-9]+\.)*[0-9]+).*!\1!'
)"
TMP="/tmp/asdf-${VERSION}-linux-amd64.tar.gz"
wget -O "$TMP" "https://github.com/asdf-vm/asdf/releases/download/${VERSION}/asdf-${VERSION}-linux-amd64.tar.gz"
echo "Extracting to /usr/local/bin"
sudo tar --extract --gunzip --directory=/usr/local/bin -f "$TMP"
rm "$TMP"
