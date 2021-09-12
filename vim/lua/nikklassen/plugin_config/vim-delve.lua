local keymappings = require 'nikklassen.keymappings'

return {
  configure = function()
    vim.g.delve_project_root = ''
    keymappings.nnoremap('<F5>', '<cmd>DlvToggleBreakpoint<CR>')
    keymappings.nnoremap('<F7>', '<cmd>DlvConnect :5005<CR>')
  end
}
