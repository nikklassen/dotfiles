if not vim.uv.fs_stat(vim.env.HOME .. '/.vim.local') then
  return
end

vim.opt.rtp:append(vim.env.HOME .. '/.vim.local')
require('local')
