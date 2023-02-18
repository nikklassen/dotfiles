local onedark = require 'onedark'

return {
    configure = function()
        onedark.setup {
            highlights = {
                -- ['@parameter'] = {fg = '$fg'},
                ['@namespace'] = { fg = '$fg' },
            }
        }
        onedark.load()
        vim.cmd('hi! link @defaultLibrary @constant.builtin')
        vim.cmd('hi! link @deprecated @text.strike')
    end,
}
