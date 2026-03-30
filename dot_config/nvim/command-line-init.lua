vim.o.ft = 'zsh'

vim.g.abolish_no_mappings = 1

vim.pack.add({
  -- 'https://github.com/dstein64/vim-startuptime',
  'https://github.com/tpope/vim-sensible',
  'https://github.com/kylechui/nvim-surround',
  'https://github.com/echasnovski/mini.operators',
  'https://github.com/tpope/vim-abolish',
  'https://github.com/windwp/nvim-autopairs',
})

require('nvim-autopairs').setup({
  enable_check_bracket_line = false,
})
require('nvim-surround').setup {}
require('mini.operators').setup {
  replace = {
    prefix = 'cr',
  },
}
vim.keymap.set('n', 'ga', '<Plug>(abolish-coerce-word)')

require('nikklassen.keymappings')
