---@param n TSNode
---@param type string
---@return TSNode | nil
local function child_with_type(n, type)
  if n == nil then
    return nil
  end
  for child, _ in n:iter_children() do
    if child:type() == type then
      return child
    end
  end
  return nil
end

return {
  surrounds = {
    y = {
      add = function()
        local user_input = require('nvim-surround.config').get_input('Enter type: ')
        if user_input then
          return { { user_input .. '<' }, { '>' } }
        end
      end,
      delete = function()
        local n = vim.treesitter.get_node()
        local type_arguments
        while true do
          if n == nil then
            return
          end
          if n:type() == 'user_type' then
            type_arguments = child_with_type(n, 'type_arguments')
            if type_arguments ~= nil then
              break
            end
          end
          n = n:parent()
        end
        if n == nil or type_arguments == nil then
          return
        end
        local n_start_row, n_start_col, _ = n:start()
        local n_end_row, n_end_col, _ = n:end_()
        local args_start_row, args_start_col, _ = type_arguments:start()
        local args_end_row, args_end_col, _ = type_arguments:end_()
        return {
          left = {
            first_pos = { n_start_row + 1, n_start_col + 1 },
            last_pos = { args_start_row + 1, args_start_col + 1 },
          },
          right = {
            first_pos = { args_end_row + 1, args_end_col },
            last_pos = { n_end_row + 1, n_end_col },
          },
        }
      end,
    }
  }
}
