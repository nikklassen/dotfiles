local M = {}

function M.configure()
    vim.api.nvim_create_user_command('Files', "call fzf#vim#files(<q-args>, {'options': '--tiebreak=index'}, <bang>0)", {
        force = true,
        bang = true,
        nargs = '?',
        complete = 'dir',
    })

    local opts = {
        noremap = true,
        silent = true,
    }
    vim.api.nvim_set_keymap('n', '<c-p>', '<cmd>Files<CR>', opts)
    vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>Buffers<CR>', opts)

    vim.g.fzf_layout = { up = '~40%' }
    vim.g.fzf_preview_window = {}
end

return M
