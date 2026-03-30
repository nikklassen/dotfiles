if not vim.uv.fs_stat(vim.env.HOME .. '/.vim.local') or vim.env.NVIM_COMMAND_LINE == '1' then
  return
end

vim.opt.rtp:append(vim.env.HOME .. '/.vim.local')
require('local')
