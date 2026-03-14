vim.cmd([[
  hi Pmenu ctermbg=Blue
  hi clear Conceal
]])

-- vim.g.rehash256 = 1
vim.o.background = 'dark'
vim.o.termguicolors = true

vim.api.nvim_create_autocmd('TextYankPost', {
  pattern = '*',
  callback = function()
    vim.highlight.on_yank { timeout = 500 }
  end,
})

local function hi_link(from, to)
  vim.cmd.highlight { 'link', from, to, bang = true }
end

hi_link('@lsp.type.variable', '@variable')
hi_link('@lsp.type.variable.go', '@variable')
hi_link('@lsp.type.property', '@field')
hi_link('@lsp.typemod.variable.defaultLibrary', '@constant.builtin')
hi_link('@lsp.typemod.enumMember.defaultLibrary', '@constant.builtin')
