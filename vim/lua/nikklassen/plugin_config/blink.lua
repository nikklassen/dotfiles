local M = {
  lsp_icons = {
    copilot = {
      text = '',
      highlight = 'CmpItemKindCopilot',
    },
  }
}

local function kind_icon_text(ctx)
  local icon = vim.tbl_get(M.lsp_icons, ctx.item.source_id, 'text') or ctx.kind_icon
  return icon .. ctx.icon_gap
end

local function kind_icon_highlight(ctx)
  return vim.tbl_get(M.lsp_icons, ctx.item.source_id, 'highlight') or ctx.kind_hl
end

M.kind_icon = {
  text = kind_icon_text,
  highlight = kind_icon_highlight,
}

return M
