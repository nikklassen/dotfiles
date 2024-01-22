local utils = require('nikklassen.utils')

if utils.uv.fs_stat(vim.env.HOME .. '/.vim.local') then
    vim.opt.rtp:append(vim.env.HOME .. '/.vim.local')
    return {
        { import = 'local' },
    }
else
    return {}
end
