function is-jj() {
  find-vcs-up .jj
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
  [grb]="jj rebase --destination"
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

alias jjmv="jj squash"
alias jjd="jj describe -m"
alias jjn="jj next"
alias jjne="jj next --edit"
alias jjp="jj prev"
alias jjpe="jj prev --edit"
alias jjnw="jj new"
alias jjbs="jj bookmark set"
alias jjbm="jj bookmark move"

alias gpm="jj bookmark set main -r @- && gp"
