require('hardtime').setup {
  disabled_filetypes = { 'qf', 'NvimTree', 'lazy', 'hunk', 'TelescopePrompt' },
  disabled_keys = {
    ['<Up>'] = false,
    ['<Down>'] = false,
  },
  hints = {
    ['d%$'] = nil,
    ['[^g]d%$'] = {
      message = function()
        return 'Use D instead of d$'
      end,
      length = 3,
    },
  },
}
