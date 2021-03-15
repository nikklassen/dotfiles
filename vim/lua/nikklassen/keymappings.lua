local map = vim.api.nvim_set_keymap
local vnoremap = function(lhs, rhs)
  map('v', lhs, rhs, { noremap = true })
end
local tnoremap = function(lhs, rhs)
  map('t', lhs, rhs, { noremap = true })
end
local nnoremap = function(lhs, rhs)
  map('n', lhs, rhs, { noremap = true })
end

-- Search for the currently selected text
vnoremap('//', '"sy/<C-r>s<CR>')

tnoremap('<M-h>', '<C-\\><C-n><C-w>h')
tnoremap('<M-j>', '<C-\\><C-n><C-w>j')
tnoremap('<M-k>', '<C-\\><C-n><C-w>k')
tnoremap('<M-l>', '<C-\\><C-n><C-w>l')

nnoremap('Y', 'y$')

-- Reindent whole file
nnoremap('<leader>=', 'mrgg=G`r')

nnoremap('<C-S>', '<cmd>w<CR>')

map('n', '<space>', 'foldlevel(".") ? "za" : "<space>"', {
  silent = true,
  expr = true,
  noremap = true,
})

vnoremap('<', '<gv')
vnoremap('<leader><', '<')

vnoremap('>', '>gv')
vnoremap('<leader>>', '>')

nnoremap('gp', '`[v`]')

nnoremap('<Left>', 'gT')
nnoremap('<Right>', 'gt')

nnoremap('<F4>', '<cmd>cnext<CR>')
-- Shift F4
nnoremap('<F16>', '<cmd>cprevious<CR>')

nnoremap('<M-Down>', 'ddp')
nnoremap('<M-Up>', 'ddkP')

vnoremap('<M-Down>', 'dpgv')
vnoremap('<M-Up>', 'dkPgv')

local config_path = vim.fn.stdpath('config')
nnoremap('<leader>v', '<cmd>tabe ' .. config_path .. '/init.lua<CR>')
nnoremap('<leader>vp', '<cmd>tabe ' .. config_path .. '/lua/nikklassen/plugins.lua<CR>')

nnoremap('<M-h>', '<C-W>h')
nnoremap('<M-j>', '<C-W>j')
nnoremap('<M-k>', '<C-W>k')
nnoremap('<M-l>', '<C-W>l')
nnoremap('<M-c>', '<C-w>c')

vim.o.pastetoggle = '<F5>'

nnoremap('<F10>', '1z=')

-- build
nnoremap('<leader>m', '<cmd>w | make<CR>')

map('c', '<C-A>', '<Home>', {})
map('c', '<M-b>', '<S-Left>', {})
map('c', '<M-f>', '<S-Right>', {})

nnoremap('<leader>c', '<cmd>cd expand("%:p:h")<CR>')

local function replace_current_word()
    local new_word = vim.fn.input('New word: ')
    if new_word == '' then
        return
    end

    local w = vim.fn.expand('<cword>')
    local new_line = vim.api.nvim_get_current_line():gsub(w, new_word)
    vim.api.nvim_set_current_line(new_line)
end

nnoremap('<leader>s', '<cmd>lua require"nikklassen.keymappings".replace_current_word()<CR>')

map('v', '<C-S>', "<cmd>'<,'>sort<CR>", { noremap = true, silent = true })

local function run_lines()
  local selected_text = vim.fn.getline("'<", "'>")
  vim.api.nvim_exec(selected_text, false)
end

-- Run selected lines
map('v', '<f2>', '<cmd>lua require"nikklassen.keymappings".run_lines()<cr>', {
  noremap = true,
  silent = true,
})

nnoremap('<BS>', '<c-^>')

nnoremap('ZA', '<cmd>wqa<CR>')

return {
  replace_current_word = replace_current_word,
  run_lines = run_lines,
}
