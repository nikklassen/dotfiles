local other = require("other-nvim")

return {
    configure = function()
        other.setup({
            mappings = {
                'golang'
            },
        })
        vim.keymap.set('n', '<M-r>', other.open, { noremap = true, silent = true })
    end,
}
