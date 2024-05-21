declare -A vcs_detect
declare -A vcs_alias

function which-vcs() {
  for vcs detect in "${(@kv)vcs_detect}"; do
    if eval "$detect"; then
      echo "$vcs"
      return 0
    fi
  done
  cat >&2 <<< "no VCS detected"
  return 1
}

function which-vcs-alias() {
  local fn="$1"; shift
  local vcs="$(which-vcs)"
  [[ -z "$vcs" ]] && return 1
  echo "${vcs_alias[${vcs}_${fn}]}"
}

function vcs-cmd() {
  local fn="$1"; shift
  local alias="$(which-vcs-alias "$fn")"
  [[ -z "$alias" ]] && return 1
  eval "${alias}" "${@:q}"
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

function find-vcs-up() {
  local path="$PWD"
  while [[ -n "$path" ]]; do
    if [[ -d "${path}/$1" ]]; then
      return 0
    fi
    path="${path%/*}"
  done
  return 1
}

source vcs/git.zsh
source vcs/hg.zsh
source vcs/jj.zsh

alias hx=glog
