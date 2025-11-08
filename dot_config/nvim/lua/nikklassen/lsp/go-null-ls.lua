local null_ls = require('null-ls')

local function split_struct_action()
  local actions = {}
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor[1] - 1
  local col_num = cursor[2]

  local parser = vim.treesitter.get_parser(0, 'go')
  if not parser then return end
  local tree = parser:parse()[1]
  if not tree then return end
  local root = tree:root()

  local node = root:descendant_for_range(line_num, col_num, line_num, col_num)
  if not node then return end

  -- Find the enclosing composite_literal
  local comp_literal
  while node do
    if node:type() == 'composite_literal' then
      comp_literal = node
      break
    end
    node = node:parent()
  end

  if not comp_literal then return end

  local sr, sc, er, ec = comp_literal:range()
  if sr ~= er then
    return -- Already multi-line
  end

  local literal_value = nil
  for child in comp_literal:iter_children() do
    if child:type() == 'literal_value' then
      literal_value = child
      break
    end
  end

  if not literal_value then return end

  actions[#actions + 1] = {
    title = 'Split struct literal',
    action = function()
      local current_line = vim.api.nvim_buf_get_lines(0, sr, sr + 1, false)[1]
      local line_prefix = current_line:sub(1, sc)
      local indent = current_line:match('^%s*')
      local inner_indent = indent .. (vim.bo.expandtab and string.rep(' ', vim.bo.shiftwidth) or '\t')

      local type_node = comp_literal:child(0)
      if type_node == nil then return end

      local type_text = vim.treesitter.get_node_text(type_node, 0)

      local new_lines = { line_prefix .. type_text .. '{' }

      local elements = { '' }

      for child in literal_value:iter_children() do
        local child_text = vim.treesitter.get_node_text(child, 0)

        if child_text == '}' then
          elements[#elements] = elements[#elements] .. ','
        elseif child_text ~= '{' then
          elements[#elements] = elements[#elements] .. ' ' .. child_text
        end
        if child_text == ',' then
          table.insert(elements, '')
        end
      end

      for _, element in ipairs(elements) do
        table.insert(new_lines, inner_indent .. element)
      end

      local remaining = current_line:sub(ec + 1)
      table.insert(new_lines, indent .. '}' .. remaining)

      vim.api.nvim_buf_set_lines(0, sr, er + 1, false, new_lines)
    end,
  }
  return actions
end

return {
  name = 'Go',
  method = null_ls.methods.CODE_ACTION,
  filetypes = { 'go' },
  generator = {
    fn = split_struct_action,
  },
}
