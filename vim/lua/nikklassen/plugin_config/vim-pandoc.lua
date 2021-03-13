local M = {}

function M.configure()
    vim.g['pandoc#modules#disabled'] = {'formatting'}
    vim.g['pandoc#syntax#conceal#use'] = 0
    vim.g['pandoc#syntax#codeblocks#embeds#langs'] = {'java', 'c'}
    vim.g['pandoc#command#autoexec_command'] = 'Pandoc pdf -R -Ss -f markdown+hard_line_breaks+subscript+superscript+pipe_tables -V geometry:margin=1in'
    vim.g['pandoc#formatting#mode'] = 'ha'
    if vim.fn.executable('pandoc') == 1 then
        vim.g['pandoc#command#autoexec_on_writes'] = 1
    end
end

return M
