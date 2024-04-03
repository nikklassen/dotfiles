alias hg='chg'

function is-hg() {
  find-vcs-up .hg
}

function _hga() {
    hg fixwdir && hg amend "$@" && hg evolve
}

function hg_unshelve_drop() {
  stash=$(hg shelve -l | awk 'NR == 1 {print $1}')
  echo dropping $stash
  hg shelve -d $stash
}

function _hg_gcmsg() {
  local msg="$1"; shift
  hg fixwdir && hg commit -m "$msg" "$@"
}


declare -A hg_aliases=(
  [gst]="hg status"
  [ga]="hg add"
  [gl]="hg sync"
  [gco]="hg checkout"
  [gp]="hg upload"
  [gpa]="hg upload --all"
  [gm]="hg merge"
  [gsh]="hg diff -c ."
  [gclean]="hg clean"
  [gsta]="hg shelve"
  [gstp]="hg unshelve"
  [gstd]='hg_unshelve_drop'
  [gstl]='hg shelve -l'
  [gsts]='hg shelve -p'
  [grs]='hg revert'
  [gc]='hg commit'
  [gc!]='_hga'
  [gci]="hg commit -i"
  [grm]='hg rm'
  [grb]='hg rebase'
  [grbc]='hg rebase --continue'
  [gcmsg]="_hg_gcmsg"
  [gd]="hg diff"
  [glog]="hg xl"
)

alias hgra="hg revert --all"
alias he="hg evolve --any"
alias hx="hg xl"
alias hhe="hg histedit"
alias hhec="hg histedit --continue"

register-vcs hg is-hg hg_aliases
