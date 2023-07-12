local onedark = require 'onedark'

return {
    configure = function()
        onedark.setup {
            highlights = {
            }
        }
        onedark.load()
        vim.cmd('hi! link @lsp.type.variable @variable')
        vim.cmd('hi! link @lsp.type.property @field')
        vim.cmd('hi! link @lsp.type.namespace @variable')
        vim.cmd('hi! link @lsp.typemod.variable.defaultLibrary @constant.builtin')
        vim.cmd('hi! link @lsp.typemod.enumMember.defaultLibrary @constant.builtin')
    end,
}
