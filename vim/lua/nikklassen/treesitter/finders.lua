local M = {}

---@param n TSNode|nil
---@param type string
---@return TSNode?
function M.parent_by_type(n, type)
  while true do
    if n == nil then
      return nil
    end
    if n:type() == type then
      return n
    end
    n = n:parent()
  end
end

return M
