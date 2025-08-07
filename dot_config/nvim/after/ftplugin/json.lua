local yank = require('nikklassen.yank')

vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
yank.set_buffer_key('p', function()
  return require('jsonpath').get()
end)
