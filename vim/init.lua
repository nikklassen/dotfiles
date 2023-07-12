vim.o.compatible = false

vim.o.shell = '/bin/bash'

require 'nikklassen.plugins'
require 'nikklassen.color'
require 'nikklassen.commands'
require 'nikklassen.keymappings'
require 'nikklassen.options'
require 'nikklassen.statusline'
require 'nikklassen.view'

vim.o.runtimepath = vim.o.runtimepath .. ',' .. vim.fn.expand('~/.vim.local')

local local_vimrc = vim.fn.expand('~/.vimrc.local')
if vim.fn.filereadable(local_vimrc) == 1 then
    vim.cmd('source ' .. local_vimrc)
end
