return {
    configure = function ()
        vim.g.delve_enable_syntax_highlighting = 0
        vim.g.delve_project_root = ''
        vim.keymap.set('n', '<F7>', '<cmd>DlvConnect :5005<CR>')
        vim.keymap.set('n', '<F9>', '<cmd>DlvToggleBreakpoint<CR>')
    end,
}

