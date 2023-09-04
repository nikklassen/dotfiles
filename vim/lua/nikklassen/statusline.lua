local utils = require 'nikklassen.utils'
local lsp_status
if utils.isModuleAvailable('lsp-status') then
    lsp_status = require 'lsp-status'.status
end

local function git_sl()
    local ok, head = pcall(vim.fn.FugitiveHead)
    if not ok then
        return ''
    end
    if head ~= '' then
        return ' @ ' .. head
    end
    return ''
end

local function lsp_sl()
    local clients = vim.lsp.get_active_clients({
        bufnr = 0,
    })
    if vim.tbl_isempty(clients) then
        return ''
    end
    local lsps = ''
    for _, client in ipairs(clients) do
        lsps = '{' .. client.name .. '}'
    end
    if lsp_status ~= nil then
        lsps = lsps .. ' ' .. lsp_status()
    end
    return lsps
end

function _G.nikklassen_statusline()
    return table.concat({
        '[%n] ',   -- buffer number
        '%<%.99f', -- file name
        git_sl(),
        ' ',
        '%h%m%r%w%q', -- flags
        '%=',         -- right align
        lsp_sl(),
        ' ',
        '%y ',           -- file type
        '%-8( %l,%c %)', -- offset
    })
end

vim.o.statusline = '%!v:lua.nikklassen_statusline()'
