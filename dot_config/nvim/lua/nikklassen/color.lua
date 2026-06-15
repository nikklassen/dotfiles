-- Load onedark here so that the "from" group in the hi_link commands below works
vim.pack.add({
  {
    src = 'https://github.com/navarasu/onedark.nvim',
    version = vim.version.range('*'),
  },
})

local onedark = require 'onedark'
onedark.setup()
onedark.load()

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
