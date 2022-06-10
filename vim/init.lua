vim.o.compatible = false

vim.o.shell = '/bin/bash'

local vim_local_dir = vim.env.HOME .. '/.vim.local'
if vim.fn.isdirectory(vim_local_dir) == 1 then
    package.path = package.path .. ';' .. vim_local_dir .. '/lua/?/init.lua'
end

require'nikklassen.plugins'
require'nikklassen.color'
require'nikklassen.commands'
require'nikklassen.keymappings'
require'nikklassen.options'
require'nikklassen.statusline'
require'nikklassen.view'

local local_vimrc = vim.fn.expand('~/.vimrc.local')
if vim.fn.filereadable(local_vimrc) == 1 then
    vim.cmd('source ' .. local_vimrc)
end
