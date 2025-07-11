_JJ_INSTALLED=0
if command -v jj >/dev/null 2>&1; then
  _JJ_INSTALLED=1
fi

function is-jj() {
  (( _JJ_INSTALLED )) && find-vcs-up .jj
}

function _jj_gcmsg() {
  local msg="$1"; shift
  jj describe -m "$msg"; jj new
}

function _jj_gd() {
  jj diff --git "$@" | delta
}

declare -A jj_aliases=(
  [gst]="jj status"
  [gl]="jj git fetch"
  [gco]="jj edit"
  [gcoh]="jj new -r 'trunk()'"
  [gp]="jj git push --all"
  [gm]="jj new @"
  [gsh]="jj show"
  [gc!]="jj squash"
  [gci]="jj split -i"
  [grb]="jj rebase"
  [gcmsg]="_jj_gcmsg"
  [gd]="_jj_gd"
  [glog]="jj log"
  [grs]="jj restore"
  [grhh]="jj abandon"
  [grbm]="jj rebase --destination 'trunk()'"
  [gf]="jj git fetch"

  # Don't know yet
  # [gclean]=""
)

register-vcs jj is-jj jj_aliases

alias jjmv="echo 'use jjsq'"
alias jjd="echo 'use jjdmsg'"
alias jjne="jj next --edit"
alias jjpe="jj prev --edit"
alias jjnw="echo 'use jjn'"
alias jjbs="jj bookmark set"
alias jjbm="jj bookmark move"
alias jjbd="jj bookmark delete"

alias gpm="jj bookmark set main -r @- && gp"
