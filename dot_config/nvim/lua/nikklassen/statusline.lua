local lsp_status = nil

vim.api.nvim_create_autocmd('LspProgress', {
  pattern = '*',
  callback = function()
    lsp_status = { os.time(), vim.lsp.status() }
    vim.cmd.redrawstatus()
  end,
})

local function lsp_sl()
  local clients = vim.lsp.get_clients({
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
    local since_update = os.time() - lsp_status[1]
    if since_update > 1 then
      lsp_status = nil
    else
      lsps = lsps .. ' ' .. lsp_status[2]
    end
  end
  return lsps .. ' ' .. vim.diagnostic.status()
end

function _G.nikklassen_statusline()
  local progress = vim.ui.progress_status()
  if #progress > 0 then
    progress = progress .. ' '
  end
  return table.concat({
    '[%n] ',      -- buffer number
    '%<%.99f',    -- file name
    '%h%m%r%w%q', -- flags
    '%=',         -- right align
    lsp_sl(),
    ' ',
    progress,
    '%y ',           -- file type
    '%-8( %l,%c %)', -- offset
  })
end

vim.o.statusline = '%!v:lua.nikklassen_statusline()'
