Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Remove-PSReadlineKeyHandler 'Ctrl+r'
Remove-PSReadlineKeyHandler 'Ctrl+t'
Import-Module PSFzf

function ga { git add @args }
function gd { git diff @args }
function gdca { git diff --cached @args }
function gl { git pull @args }
function gst { git status @args }
function glog { git log --oneline --decorate --graph }
function hx { glog }

function cma { chezmoi apply }

Set-Alias which Get-Command

$env:FZF_DEFAULT_COMMAND='fd --type f'
$env:FZF_CTRL_T_COMMAND="$env:FZF_DEFAULT_COMMAND"
$env:FZF_DEFAULT_OPTS="--keep-right --bind=home:first,end:last"

$env:TERM='xterm-256color'

cd ~\.local\share\chezmoi
