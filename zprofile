if grep -q "\-WSL2" /proc/version > /dev/null 2>&1; then
  if service docker status 2>&1 | grep -q "is not running"; then
    echo "Starting docker"
    wsl.exe --distribution "${WSL_DISTRO_NAME}" --user root \
      --exec /usr/sbin/service docker start > /dev/null 2>&1
  fi
fi

[ -f ~/.zprofile.local ] && source ~/.zprofile.local
