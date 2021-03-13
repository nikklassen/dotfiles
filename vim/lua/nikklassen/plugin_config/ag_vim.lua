local M = {}

function M.configure()
    vim.api.nvim_set_keymap('n', '<leader>ag', '<cmd>Ag <C-r><C-w><CR>', {
        noremap = true,
        silent = true,
    })
    vim.api.nvim_set_keymap('v', '<leader>ag', [["gy:Ag -Q "<C-R>=substitute(@g, '\\\@<!"', '\\"', 'g')<CR>"<CR>]], {
        noremap = true,
        silent = true,
    })
end

return M
