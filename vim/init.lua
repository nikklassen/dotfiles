vim.o.compatible = false

vim.o.shell = '/bin/bash'

package.path = package.path .. ';' .. vim.fn.expand('~/.luarocks/share/lua/5.1/?.lua')
package.cpath = package.cpath .. ';' .. vim.fn.expand('~/.luarocks/lib/lua/5.1/?.so')

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable", -- latest stable release
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

require('lazy').setup('nikklassen.plugins')

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
