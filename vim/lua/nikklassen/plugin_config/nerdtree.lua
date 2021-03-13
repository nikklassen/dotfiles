local M = {}

function M.configure()
    vim.cmd('autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif')
    vim.g.NERDTreeIgnore = {'pyc$'}
    vim.g.NERDTreeQuitOnOpen = 1
    vim.g.NERDTreeWinSize = 20

    local opts = {
        noremap = true,
        silent = true,
    }
    vim.api.nvim_set_keymap('n', '<leader>n', '<cmd>NERDTreeToggle<CR>', opts)
    vim.api.nvim_set_keymap('n', '<leader>nf', '<cmd>NERDTreeFind<CR>', opts)
end

return M
