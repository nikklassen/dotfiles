vim.o.compatible = false

vim.o.shell = '/bin/bash'

-- Must be set before loading lazy
vim.g.mapleader = ' '

local home = vim.env.HOME

package.path = package.path .. ';' .. home .. '/.luarocks/share/lua/5.1/?.lua'
package.cpath = package.cpath .. ';' .. home .. '/.luarocks/lib/lua/5.1/?.so'

require 'nikklassen.filetypes'
require 'nikklassen.color'
require 'nikklassen.commands'
require 'nikklassen.keymappings'
require 'nikklassen.options'
require 'nikklassen.statusline'
require 'nikklassen.view'
require 'nikklassen.lsp'
