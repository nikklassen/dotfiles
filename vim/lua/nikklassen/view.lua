local function should_persist_view()
    local dir = vim.fn.expand('%:p')
    return (
      vim.fn.expand('%:t') ~= '' and
      dir:find('fugitive://') == nil and
      dir:find('term://') == nil
    )
end

function _G.save_view_settings()
    if should_persist_view() then
        vim.cmd('mkview!')
    end
end

function _G.load_view_settings()
    if should_persist_view() then
        vim.cmd('silent! loadview')
    end
end

vim.api.nvim_exec([[
augroup remember_folds
	au!
	au BufWinLeave * lua save_view_settings()
	au BufWinEnter * lua load_view_settings()
augroup END
]], false)

-- Jump to the last position on load
vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]])

vim.wo.foldminlines = 4
vim.wo.foldnestmax = 3
vim.o.foldopen = 'block,hor,mark,percent,quickfix,search,tag,undo,jump'

function _G.adjust_qf_height(minheight, maxheight)
    local height = math.max(math.min(vim.fn.line('$'), maxheight), minheight)
    vim.api.nvim_win_set_height(0, height)
end

-- Keep the quickfix window small when there aren't many lines
vim.cmd('au FileType qf call v:lua.adjust_qf_height(3, 10)')

