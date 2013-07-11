" Vim syntax file
" Language: D&D 4e stat block
"
" Keywords to highlight:

syn keyword 4eLabel	Level XP Initiative HP AC Speed Fortitude Reflex Will Reach dominated stunned weakened dazed slowed Senses darkvision Resist Saving Throws fly teleport Action Points prone Close burst blast Bloodied Petrified Marked Unconscious Surprised Immobilized Helpless Deafened Blinded Restrained
syn match   4eSave "(save ends\( both\)\?)"
syn keyword 4eActionD standard move minor free		contained
syn keyword 4eActionW standard move minor free		contained
syn keyword 4eActionE standard move minor free		contained
syn keyword 4eActionR standard move minor free		contained
syn keyword 4eActionI immmediate contained

syn match 4eDaily			"^.*daily).*$" 	contains=4eActionD
syn match 4eWill			"^.*at-will).*$" 	contains=4eActionW
syn match 4eEncounter 		"^.*encounter).*$" 	contains=4eActionE
syn match 4eRecharge		"^.*recharges\? .*).*" 	contains=4eActionR
syn match 4eInterrupt		"^.*interrupt.*).*" 	contains=4eActionI
syn match 4eSecondary           "^Secondary Attack$"    
syn match 4eNonAction       "^\D\+[^\.]$"   contains=ALLBUT,x4eDaily,x4eWill,x4eEncounter,x4eRecharge,x4eInterrupt,x4eSecondary
"syn match free

syn match 4eNumber 			/+\?-\?\d\+d\?/ " match numbers, include + or - sign
syn region 4eTitle start="^.*\n.*\nLevel.*\n\?XP.*" end="XP.*$"

hi 4eDaily 			ctermbg=white 	ctermfg=black
hi 4eWill  			ctermbg=22		ctermfg=white
hi 4eEncounter 		ctermbg=88	 	ctermfg=white
hi 4eRecharge		ctermbg=55
hi 4eInterrupt		ctermbg=blue
hi 4eLabel 			cterm=bold 		ctermfg=228
hi 4ePowerText 		ctermbg=red
hi 4eTitle 			ctermbg=18 		cterm=bold 	gui=bold guifg=DeepSkyBlue2
hi 4eNumber 		ctermfg=208		guifg=goldenrod3
hi 4eSave			ctermfg=159 	cterm=bold
hi 4eActionD		ctermbg=white ctermfg=black cterm=underline
hi 4eActionW		ctermbg=22  cterm=underline
hi 4eActionE		ctermbg=88 cterm=underline
hi 4eActionR		ctermbg=55 cterm=underline
hi 4eActionI		ctermbg=blue cterm=underline
hi 4eNonAction      ctermbg=234
hi 4eSecondary      cterm=underline 
"hi 4eAction			cterm=underline

hi CursorLine 		ctermbg=none cterm=bold
set nonumber
set wrap

