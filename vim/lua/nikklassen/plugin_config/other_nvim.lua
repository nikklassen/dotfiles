return {
    setup = function(opts)
        local other = require 'other-nvim'

        local open = opts.open or other.open
        vim.keymap.set('n', '<M-r>', open, { noremap = true, silent = true })

        other.setup(opts)
    end,
}
