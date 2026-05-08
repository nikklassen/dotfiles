local ts = require('nikklassen.lsp.treesitter')
local finders = require('nikklassen.treesitter.finders')

---@param bufnr integer
---@param node TSNode
---@return lsp.CodeAction
local function to_synthetic_getter_action(bufnr, node)
  local value = vim.treesitter.get_node_text(node, bufnr)
  local new_value = value:sub(4, 4):lower() .. value:sub(5)
  local start_row, start_col, _ = node:start()
  local end_row, end_col, _ = node:end_()

  return {
    title = 'Convert to synthetic getter',
    kind = 'refactor.rewrite',
    edit = {
      changes = {
        [vim.uri_from_bufnr(bufnr)] = {
          {
            range = {
              start = { line = start_row, character = start_col },
              ['end'] = { line = end_row, character = end_col + 2 },
            },
            newText = new_value,
          }
        }
      }
    }
  }
end

---@param bufnr integer
---@param setter TSNode
---@return lsp.CodeAction?
local function to_synthetic_setter_action(bufnr, setter)
  local value = vim.treesitter.get_node_text(setter, bufnr)
  local setter_end_row, setter_end_col, _ = setter:end_()

  local next_node = vim.treesitter.get_node({
    bufnr = bufnr,
    pos = { setter_end_row, setter_end_col + 1 },
  })
  local n = finders.parent_by_type(next_node, 'call_suffix')
  if n == nil then
    return nil
  end

  local property = value:sub(4, 4):lower() .. value:sub(5)

  local start_row, start_col, _ = setter:start()
  local parens_start_row, parens_start_col, _ = n:start()
  local parens_end_row, parens_end_col, _ = n:end_()

  local set_value = vim.api.nvim_buf_get_text(bufnr, parens_start_row, parens_start_col + 1, parens_end_row,
    parens_end_col - 1, {})
  set_value[1] = property .. ' = ' .. set_value[1]

  return {
    title = 'Convert to synthetic setter',
    kind = 'refactor.rewrite',
    edit = {
      changes = {
        [vim.uri_from_bufnr(bufnr)] = {
          {
            range = {
              start = { line = start_row, character = start_col - 1 }, -- include the .
              ['end'] = { line = parens_end_row, character = parens_end_col },
            },
            newText = table.concat(set_value, '\n'),
          }
        }
      }
    }
  }
end

local M = {}

---@param bufnr integer
---@param params { range: lsp.Range }
---@return lsp.CodeAction[]
function M.actions(bufnr, params)
  local actions = {}

  local tree = ts.parse_buffer(bufnr, 'kotlin')
  if not tree then return {} end
  local line = params.range.start.line
  local col = params.range.start.character
  local node = ts.get_node_at_position(tree, line, col)
  if not node then return {} end

  if node:type() == 'simple_identifier' then
    local value = vim.treesitter.get_node_text(node, bufnr)
    if string.match(value, [[^get%u%w+]]) then
      local action = to_synthetic_getter_action(bufnr, node)
      table.insert(actions, action)
    elseif string.match(value, [[^set%u%w+]]) then
      local action = to_synthetic_setter_action(bufnr, node)
      if action then table.insert(actions, action) end
    end
  end

  return actions
end

return M
