vim.pack.add({
  {
    src = 'https://github.com/mistweaverco/kulala.nvim',
    version = vim.version.range('*'),
  },
})

require('kulala').setup {
  -- your configuration comes here
  -- global_keymaps = false,
  global_keymaps = true,
  global_keymaps_prefix = '<leader>R',
  kulala_keymaps_prefix = '',
  ui = {
    pickers = {
      telescope = {}
    }
  }
}
