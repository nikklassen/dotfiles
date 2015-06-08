" Don't remove indent when typing comments
inoremap # X#

function! PrintPyVar()
    let line = getline('.')
    let l:pre = col('.') - 1
    let nesting = 0
    while line[l:pre] !~ '\s' && l:pre > 0
        if line[l:pre] == '('
            if nesting == 0
                break
            endif
            let nesting -= 1
        elseif line[l:pre] == ')'
            let nesting += 1
        endif
        let l:pre -= 1
    endwhile
    let l:pre += 1

    let l:post = col('.')
    let l:len = len(line)
    while line[l:post] =~ '[a-zA-Z0-9_]' && l:post <= l:len
        let l:post += 1
    endwhile
    let l:post -= 1

    let value = line[l:pre : l:post]
    let failed = append(line('.'), "print '" . value . ":', " . value)
    +1,+1normal ==
endfunction

command! PrintPyVar call PrintPyVar()

nmap <leader>pr :PrintPyVar<CR>
