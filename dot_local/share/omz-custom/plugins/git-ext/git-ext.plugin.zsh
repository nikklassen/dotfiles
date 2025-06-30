alias gdl='git clone --depth 1'

function gbc () {
    git branch $1 && git checkout $1
}

function gbdd () {
    git branch -D $1
    git push origin :$1 --no-verify
}

function grc () {
    git reset HEAD $1 > /dev/null && git checkout $1
}

function gpnew() {
    git push --set-upstream origin "$(git rev-parse --abbrev-ref HEAD)"
}
