local aerial = require('aerial')

return {
    configure = function()
        aerial.setup()
        vim.keymap.set('n', '<leader>a', '<cmd>AerialToggle! left<CR>')
    end,
}
