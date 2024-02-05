declare -A vcs_detect
declare -A vcs_alias

function vcs-cmd() {
  local fn="$1"; shift
  for vcs detect in "${(@kv)vcs_detect}"; do
    if eval "$detect"; then
      eval "${vcs_alias[${vcs}_${fn}]}" "${@:q}"
      return $?
    fi
  done
  echo "no VCS deteccted"
}

function register-vcs() {
  local name="$1"; shift
  local detect="$1"; shift
  local aliases="$1"; shift

  vcs_detect[$name]="$detect"

  for k v in "${(@kv)${(P)aliases}}"; do
    vcs_alias[${name}_${k}]="$v"
    alias "$k"="vcs-cmd $k"
  done
}

source vcs/git.zsh
source vcs/hg.zsh
source vcs/jj.zsh

alias hx=glog
