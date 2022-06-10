vim.cmd('hi Pmenu ctermbg=Blue')
vim.cmd('hi clear Conceal')

-- vim.g.rehash256 = 1
-- vim.cmd('colorscheme molokai')
vim.o.background = 'dark'
vim.o.termguicolors = true

vim.cmd([[au TextYankPost * lua vim.highlight.on_yank { timeout = 500 }]])

