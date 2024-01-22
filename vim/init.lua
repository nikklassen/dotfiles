vim.o.compatible = false

vim.o.shell = '/bin/bash'

local home = vim.env.HOME

package.path = package.path .. ';' .. home .. '/.luarocks/share/lua/5.1/?.lua'
package.cpath = package.cpath .. ';' .. home .. '/.luarocks/lib/lua/5.1/?.so'

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

local utils = require 'nikklassen.utils'

if not utils.uv.fs_stat(lazypath) then
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

require('lazy').setup('nikklassen.plugins', {
    -- debug = true,
    change_detection = {
        notify = false,
    },
    checker = {
        enabled = true,
    },
    performance = {
        rtp = {
            disabled_plugins = {
                'matchit',
            },
        },
    },
})

require 'nikklassen.color'
require 'nikklassen.commands'
require 'nikklassen.keymappings'
require 'nikklassen.options'
require 'nikklassen.statusline'
require 'nikklassen.view'
