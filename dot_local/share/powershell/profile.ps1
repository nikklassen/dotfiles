Set-PSReadlineKeyHandler -Key Tab -Function Complete
Set-PSReadlineKeyHandler -Key UpArrow -Function HistorySearchBackward
Set-PSReadlineKeyHandler -Key DownArrow -Function HistorySearchForward

Remove-PSReadlineKeyHandler 'Ctrl+r'
Remove-PSReadlineKeyHandler 'Ctrl+t'
Import-Module PSFzf

del alias:gp -Force

function ga { jj add @args }
function gco { jj edit @args }
function gd { jj diff @args }
function gl { jj git fetch @args }
function glog { jj log @args }
function gp { jj push --all --deleted @args }
function gpm { jj bookmark set main -r '@-' && gp @args }
function gst { jj status @args }
function hx { glog }
function jjds { jj desc @args }
function jjn { jj new @args }
function jjsp { jj split @args }

function cma { chezmoi apply }

Set-Alias which Get-Command

$env:FZF_DEFAULT_COMMAND='fd --type f'
$env:FZF_CTRL_T_COMMAND="$env:FZF_DEFAULT_COMMAND"
$env:FZF_DEFAULT_OPTS="--keep-right --bind=home:first,end:last"

$env:TERM='xterm-256color'

cd ~\.local\share\chezmoi
