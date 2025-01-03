vim.keymap.set({ 'n' }, '\\', ':')

-- Search for the currently selected text
vim.keymap.set('v', '//', '"sy/<C-r>s<CR>')

vim.keymap.set('t', '<M-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set('t', '<M-j>', '<C-\\><C-n><C-w>j')
vim.keymap.set('t', '<M-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set('t', '<M-l>', '<C-\\><C-n><C-w>l')

vim.keymap.set('n', 'Y', 'y$')

-- Reindent whole file
vim.keymap.set('n', '<leader>=', 'mrgg=G`r')

vim.keymap.set({ 'n' }, '<C-S>', '<cmd>w<CR>')

-- vim.keymap.set('n', '<space>', 'foldlevel(".") ? "za" : "<space>"', {
--   silent = true,
--   expr = true,
-- })

vim.keymap.set('v', '<', '<gv')
vim.keymap.set('v', '<leader><', '<')

vim.keymap.set('v', '>', '>gv')
vim.keymap.set('v', '<leader>>', '>')

vim.keymap.set('n', 'gp', '`[v`]')

-- vim.keymap.set('n', '<Left>', 'gT')
-- vim.keymap.set('n', '<Right>', 'gt')
vim.keymap.set('n', '<Left>', '<cmd>bp<CR>')
vim.keymap.set('n', '<Right>', '<cmd>bn<CR>')

vim.keymap.set('n', '<F4>', '<cmd>cnext<CR>')
-- Shift F4
vim.keymap.set('n', '<F16>', '<cmd>cprevious<CR>')

vim.keymap.set('n', '<M-Down>', 'ddp')
vim.keymap.set('n', '<M-Up>', 'ddkP')

local config_path = vim.fn.stdpath('config')
vim.keymap.set('n', '<leader>v', '<cmd>tabe ' .. config_path .. '/init.lua<CR>')
vim.keymap.set('n', '<leader>vp', '<cmd>tabe ' .. config_path .. '/lua/nikklassen/plugin_config<CR>')

vim.keymap.set('n', '<M-h>', '<C-W>h')
vim.keymap.set('n', '<M-j>', '<C-W>j')
vim.keymap.set('n', '<M-k>', '<C-W>k')
vim.keymap.set('n', '<M-l>', '<C-W>l')
vim.keymap.set('n', '<M-c>', '<C-w>c')

vim.keymap.set('n', '<leader>m', '<cmd>messages<cr>')

vim.keymap.set('c', '<C-A>', '<Home>', {})
vim.keymap.set('c', '<M-b>', '<S-Left>', {})
vim.keymap.set('c', '<M-f>', '<S-Right>', {})
vim.keymap.set('c', '<C-k>', '<C-\\>e(strpart(getcmdline(), 0, getcmdpos() - 1))<CR>')

vim.o.cedit = '<C-x>'

vim.keymap.set('n', '<leader>c', [[<cmd>exec 'cd ' .. expand('%:h')<CR>]])

local function replace_current_word()
  local new_word = vim.fn.input('New word: ')
  if new_word == '' then
    return
  end

  local w = vim.fn.expand('<cword>')
  --- @cast w string
  local new_line = vim.api.nvim_get_current_line():gsub(w, new_word)
  vim.api.nvim_set_current_line(new_line)
end

vim.keymap.set('n', '<leader>s', replace_current_word)

local function run_lines()
  local selected_text = vim.fn.getline(vim.fn.line("'<"), vim.fn.line("'>"))
  --- @cast selected_text []string
  vim.api.nvim_exec2(table.concat(selected_text, '\n'), {})
end

-- Run selected lines
vim.keymap.set('v', '<f2>', run_lines, { silent = true })

vim.keymap.set('n', '<BS>', '<c-^>')

vim.keymap.set('n', 'ZA', '<cmd>wqa<CR>')

vim.keymap.set('v', 'Y', '<cmd>OSCYank<CR>')

vim.cmd.cabbr { '<expr>', '%%', 'expand("%:h")' }

vim.keymap.set('n', 'U', '<C-R>', { remap = false })
vim.keymap.set('n', 'gU', 'U', { remap = false })

vim.keymap.set('n', '<leader>lu', function()
  require("lazy").update()
end, { desc = "Update Lazy plugins" })

vim.cmd.abbreviate('reutrn', 'return')

vim.keymap.set('n', '<leader>yf', function() vim.fn.setreg('', vim.fn.getreg('%')) end)

vim.keymap.set('n', '<Del>', 'ciw', { remap = false })

-- Treesitter incremental selection
vim.keymap.set('n', '<CR>', function()
  if vim.bo.buftype == '' then
    require('nvim-treesitter.incremental_selection').init_selection()
  else
    vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<CR>', true, true, true), 'n')
  end
end)
vim.keymap.set('v', '<Tab>', function()
  require('nvim-treesitter.incremental_selection').node_incremental()
end)
vim.keymap.set('v', '<S-Tab>', function()
  require('nvim-treesitter.incremental_selection').node_decremental()
end)
