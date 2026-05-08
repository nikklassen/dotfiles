local M = {}

---@param bufnr number
---@param lang string
---@return TSTree?
function M.parse_buffer(bufnr, lang)
  local parser = vim.treesitter.get_parser(bufnr, lang)
  if not parser then return nil end
  local tree = parser:parse()[1]
  return tree
end

---@param tree TSTree
---@param line number
---@param col number
---@return TSNode?
function M.get_node_at_position(tree, line, col)
  if not tree then return nil end
  local root = tree:root()
  return root:descendant_for_range(line, col, line, col)
end

return M
