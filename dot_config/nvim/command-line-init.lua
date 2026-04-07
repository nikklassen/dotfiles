vim.o.ft = 'zsh'

vim.pack.add({
  'https://github.com/tpope/vim-sensible',
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/echasnovski/mini.operators',
  'https://github.com/tpope/vim-abolish',
  'https://github.com/windwp/nvim-ts-autotag',
  'https://github.com/windwp/nvim-autopairs',
})

vim.cmd.runtime('plugin/sensible.vim')
vim.cmd.runtime('plugin/nvim-ts-autotag.lua')
vim.cmd.runtime('plugin/nvim-autopairs.lua')
require('nvim-autopairs').setup({
  enable_check_bracket_line = false,
})
vim.cmd.runtime('plugin/nvim-surround.lua')
require('nvim-surround').setup {}
require('mini.operators').setup {
  replace = {
    prefix = 'cr',
  },
}

vim.g.abolish_no_mappings = 1
vim.cmd.runtime('plugin/abolish.vim')
vim.keymap.set('n', 'ga', '<Plug>(abolish-coerce-word)')

require('nikklassen.keymappings')
