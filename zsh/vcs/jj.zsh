function is-jj() {
  find-vcs-up .jj
}

function _jj_gcmsg() {
  local msg="$1"; shift
  jj describe -m "$msg"; jj new
}

declare -A jj_aliases=(
  [gst]="jj status"
  [gl]="jj git fetch"
  [gco]="jj edit"
  [gp]="jj git push --all"
  [gm]="jj new @"
  [gsh]="jj show -r @-"
  [gc!]="jj squash"
  [gci]="jj split -i"
  [grb]="jj rebase --destination"
  [gcmsg]="_jj_gcmsg"
  [gd]="jj diff"
  [glog]="jj log"
  [grs]="jj restore"

  # Don't know yet
  # [gclean]=""
)

register-vcs jj is-jj jj_aliases

alias jjmv="jj move"
alias jjd="jj describe -m"

alias gpm="jj branch set main -r @- && gp"
