return {
  setup = function(opts)
    local other = require 'other-nvim'

    local open = opts.open or other.open

    other.setup(opts)
    vim.keymap.set('n', '<M-r>', open, { noremap = true, silent = true })
  end,
}
