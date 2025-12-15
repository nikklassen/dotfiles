return {
  {
    'navarasu/onedark.nvim',
    lazy = false,
    priority = 1000,
    config = function()
      local onedark = require 'onedark'
      onedark.setup()
      onedark.load()
      vim.cmd([[
        hi! link @lsp.type.variable @variable
        hi! link @lsp.type.variable.go @variable
        hi! link @lsp.type.property @field
        hi! link @lsp.typemod.variable.defaultLibrary @constant.builtin
        hi! link @lsp.typemod.enumMember.defaultLibrary @constant.builtin
      ]])
    end,
  },
}
