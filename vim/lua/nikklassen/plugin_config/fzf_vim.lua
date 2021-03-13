local M = {}

function M.configure()
    local opts = {
        noremap = true,
        silent = true,
    }
    vim.api.nvim_set_keymap('n', '<c-p>', '<cmd>Files<CR>', opts)
    vim.api.nvim_set_keymap('n', '<leader>b', '<cmd>Buffers<CR>', opts)

    vim.g.fzf_layout = { up = '~40%' }
end

return M
