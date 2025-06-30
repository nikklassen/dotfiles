function is-git() {
  find-vcs-up .git && ! find-vcs-up .jj
}

function _git_gcmsg() {
  local msg="$1"; shift
  git commit -m "$msg" "$@"
}

# using $aliases works because this is the first to VCS to be added
declare -A git_aliases=(
  [gst]="git status"
  [ga]="git add"
  [gl]="git pull"
  [gco]="git checkout"
  [gp]="git push"
  [gm]="git merge"
  [gsh]="git show"
  [gclean]="$aliases[gclean]"
  [gsta]="git stash push"
  [gstp]="git stash pop"
  [gstd]="git stash drop"
  [gstl]="git stash list"
  [gsts]="git stash show --text"
  [grs]="git restore"
  [gc]="$aliases[gc]"
  [gc!]="$aliases[gc!]"
  [gci]="git commit -p"
  [grm]="git rm"
  [grbc]="$aliases[grbc]"
  [gcmsg]="_git_gcmsg"
  [gd]="git diff"
  [glog]="$aliases[glog]"
  [grbm]="git rebase \$(git_main_branch)"
  [gf]="$aliases[gf]"
  [gcoh]="gco HEAD"
)

register-vcs git is-git git_aliases
