vim.g.grepprg = 'rg --vimgrep --ignore-case --smart-case'
vim.g.grepformat = '%f:%l:%c:%m'

vim.api.nvim_create_user_command('Rg', function(opts)
  local query = table.concat(opts.fargs, ' ')
  vim.cmd.grep { query, bang = true, mods = { silent = true } }
  vim.cmd.copen()
end, { nargs = '+' })
