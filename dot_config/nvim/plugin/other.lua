local other_cfg = require('nikklassen.other')
local other = require 'other-nvim'

other.setup {
  mappings = {
    'golang'
  }
}

vim.keymap.set('n', '<M-r>', function()
  if other_cfg.open then
    other_cfg.open()
  else
    other.open()
  end
end, { noremap = true, silent = true })
