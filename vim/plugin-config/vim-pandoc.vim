let g:pandoc#modules#disabled = ["formatting"]
let g:pandoc#syntax#conceal#use = 0
let g:pandoc#syntax#codeblocks#embeds#langs = ["java", "c"]
let g:pandoc#command#autoexec_command = "Pandoc pdf -R -Ss -f markdown+hard_line_breaks+subscript+superscript+pipe_tables -V geometry:margin=1in"
let g:pandoc#formatting#mode = 'ha'
if executable('pandoc')
    let g:pandoc#command#autoexec_on_writes = 1
end
