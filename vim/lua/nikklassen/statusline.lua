local utils = require'nikklassen.utils'

function _G.git_sl()
    local ok, head = pcall(vim.fn.FugitiveHead)
    if not ok then
        return ''
    end
    if head ~= '' then
        return ' @ ' .. head
    end
    return ''
end

function _G.lsp_sl()
    local clients = vim.lsp.buf_get_clients(0)
    if vim.tbl_isempty(clients) then
        return ''
    end
    local lsps = ''
    for _, client in pairs(clients) do
        lsps = '{' .. client.name .. '}'
    end
    if utils.isModuleAvailable('lsp-status') then
        lsps = lsps .. ' ' .. require'lsp-status'.status()
    end
    return lsps
end

-- clear the statusline for when vimrc is reloaded
vim.o.statusline = table.concat({
    '[%n] ',         -- buffer number
    '%<%.99f',       -- file name
    '%{v:lua.git_sl()} ',
    '%h%m%r%w%q',    -- flags
    '%=',            -- right align
    '%{v:lua.lsp_sl()} ',
    '%y ',           -- file type
    '%-8( %l,%c %)', -- offset
})
