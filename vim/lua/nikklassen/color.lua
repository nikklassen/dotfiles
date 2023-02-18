vim.cmd('hi Pmenu ctermbg=Blue')
vim.cmd('hi clear Conceal')

-- vim.g.rehash256 = 1
vim.o.background = 'dark'
vim.o.termguicolors = true

vim.api.nvim_create_autocmd('TextYankPost', {
    pattern = '*',
    callback = function ()
        vim.highlight.on_yank { timeout = 500 }
    end,
})
