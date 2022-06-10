return {
    configure = function()
        vim.g.coq_settings = {
            clients = {
                tree_sitter = { enabled = false },
                tags = { enabled = false },
                buffers = { enabled = false },
                ['snippets.warn'] = {},
                tmux = { enabled = false },
            },
            keymap = {
                recommended = false,
                -- pre_select = true
            },
            ['display.icons.mode'] = 'none',
            match = {
                proximate_lines = 0,
                look_ahead = 0,
            }
        }

        vim.api.nvim_set_keymap('i', '<Esc>', 'pumvisible() ? "\\<C-e><Esc>" : "\\<Esc>"', {
            noremap = true,
            expr = true,
            silent = true,
        })
        vim.api.nvim_set_keymap('i', '<CR>', 'pumvisible() ? (complete_info().selected == -1 ? "\\<C-e><Plug>delimitMateCR" : "\\<C-y>") : "<Plug>delimitMateCR"', {
            expr = true,
            silent = true,
        })
        vim.api.nvim_set_keymap('i', '<Tab>', 'pumvisible() ? (complete_info().selected == -1 ? "\\<C-n>\\<C-y>" : "\\<C-n>") : "\\<Tab>"', {
            noremap = true,
            expr = true,
            silent = true,
        })
        -- ino <silent><expr> <BS>    pumvisible() ? "\<C-e><BS>"  : "\<BS>"
        -- ino <silent><expr> <Tab>   pumvisible() ? "\<C-n>" : "\<Tab>"
        -- ino <silent><expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<BS>"
        coq.Now('--shut-up')
    end
}
