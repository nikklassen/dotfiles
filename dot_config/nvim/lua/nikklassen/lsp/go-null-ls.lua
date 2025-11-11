local null_ls = require('null-ls')

---@return TSTree?
local function parse_current_buffer()
  local parser = vim.treesitter.get_parser(0, 'go')
  if not parser then return nil end
  local tree = parser:parse()[1]
  return tree
end

---@return number line_num
---@return number col_num
local function cursor_position()
  local cursor = vim.api.nvim_win_get_cursor(0)
  local line_num = cursor[1] - 1
  local col_num = cursor[2]
  return line_num, col_num
end

---@param tree TSTree
---@return TSNode?
local function get_current_node(tree)
  if not tree then return nil end
  local line_num, col_num = cursor_position()
  local root = tree:root()
  return root:descendant_for_range(line_num, col_num, line_num, col_num)
end

local function find_ancestor(node, type)
  local current_node = node
  while current_node do
    if current_node:type() == type then
      return current_node
    end
    current_node = current_node:parent()
  end
  return nil
end

local function get_node_text(node)
  return vim.treesitter.get_node_text(node, 0)
end

---@param node TSNode
---@param type string
---@return TSNode[]
local function children_of_type(node, type)
  local results = {}
  for child in node:iter_children() do
    if child:type() == type then
      results[#results + 1] = child
    end
  end
  return results
end

local function split_struct_action()
  local tree = parse_current_buffer()
  if not tree then return end
  local node = get_current_node(tree)
  if not node then return end

  local comp_literal = find_ancestor(node, 'composite_literal')
  if not comp_literal then return end

  local sr, sc, er, ec = comp_literal:range()
  if sr ~= er then
    return -- Already multi-line
  end

  local literals = children_of_type(comp_literal, 'literal_value')
  if #literals == 0 then return end
  local literal_value = literals[1]

  return {
    title = 'Split struct literal',
    action = function()
      local current_line = vim.api.nvim_buf_get_lines(0, sr, sr + 1, false)[1]
      local line_prefix = current_line:sub(1, sc)
      local indent = current_line:match('^%s*')
      local inner_indent = indent .. (vim.bo.expandtab and string.rep(' ', vim.bo.shiftwidth) or '\t')

      local type_node = comp_literal:child(0)
      if type_node == nil then return end

      local type_text = get_node_text(type_node)

      local new_lines = { line_prefix .. type_text .. '{' }

      local elements = { '' }

      for child in literal_value:iter_children() do
        local child_text = get_node_text(child)

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
end

local function return_param_data()
  local tree = parse_current_buffer()
  if not tree then return end
  local node = get_current_node(tree)
  if not node then return end

  local func_decl = find_ancestor(node, 'function_declaration') or find_ancestor(node, 'method_declaration')
  if not func_decl then return end

  local result_fields = func_decl:field('result')
  if #result_fields == 0 then return end

  local results = result_fields[1]

  -- Check if the cursor is within the results block
  local rsr, rsc, rer, rec = results:range()
  local line_num, col_num = cursor_position()
  if not (line_num >= rsr and line_num <= rer and (line_num ~= rsr or col_num >= rsc) and (line_num ~= rer or col_num <= rec)) then
    return
  end

  local decl = find_ancestor(node, 'parameter_declaration')
  if not decl then
    return
  end

  -- Determine the index of this parameter in the result list
  local param_index = nil
  for i, child in ipairs(children_of_type(results, 'parameter_declaration')) do
    if child == decl then
      param_index = i
      break
    end
  end

  if param_index == -1 then return end

  return {
    idx = param_index,
    results = results,
    func = func_decl,
  }
end

---@param values TSNode[]
---@param index number
---@return integer, integer, integer, integer
local function node_and_adjacent_comma_range(values, index)
  local node = values[index]
  local start_line, start_col, end_line, end_col = node:range()

  if index == 1 and #values > 1 then
    local r_next_sibling = node:next_sibling()
    if r_next_sibling and r_next_sibling:type() == ',' then
      end_line, end_col = r_next_sibling:end_()
    end
  elseif index > 1 then
    local r_prev_sibling = node:prev_sibling()
    if r_prev_sibling and r_prev_sibling:type() == ',' then
      start_line, start_col = r_prev_sibling:start()
    end
  end

  end_col = end_col + 1
  return start_line, start_col, end_line, end_col
end

---@param body TSNode
---@param param_index number
---@return lsp.TextEdit
local function remove_return_param_from_body(body, param_index)
  local changes = {}
  local query = vim.treesitter.query.parse('go', '(return_statement (expression_list) @target)')
  for _, expr_list in query:iter_captures(body, 0) do
    local return_values = expr_list:named_children()
    if param_index > #return_values then
      goto continue
    end

    local start_line, start_col, end_line, end_col = node_and_adjacent_comma_range(return_values, param_index)

    table.insert(changes, {
      range = {
        start = { line = start_line, character = start_col },
        ['end'] = { line = end_line, character = end_col - 1 }
      },
      newText = '',
    })

    ::continue::
  end
  return changes
end

local function remove_return_param(data)
  local bufnr = vim.api.nvim_get_current_buf()
  local changes = {}

  local param_index = data.idx
  local results = data.results
  local func_decl = data.func

  local result_params = children_of_type(results, 'parameter_declaration')

  -- Special case: single return parameter, remove the whole result block including parens
  if #result_params == 1 then
    local rsr, rsc, rer, rec = results:range()
    table.insert(changes, {
      range = { start = { line = rsr, character = rsc - 1 }, ['end'] = { line = rer, character = rec } },
      newText = '',
    })
  else
    local start_line, start_col, end_line, end_col = node_and_adjacent_comma_range(result_params, param_index)
    table.insert(changes, {
      range = {
        start = { line = start_line, character = start_col },
        ['end'] = { line = end_line, character = end_col - 1 },
      },
      newText = '',
    })
  end

  -- 2. Find and remove from return statements
  local body = func_decl:field('body')
  if #body > 0 then
    local body_changes = remove_return_param_from_body(body[1], param_index)
    vim.list_extend(changes, body_changes)
  end

  vim.lsp.util.apply_text_edits(changes, bufnr, 'utf-16')
end

local function remove_return_parameter_action()
  local data = return_param_data()
  if not data then
    return
  end

  return {
    title = 'Remove return parameter',
    action = function()
      remove_return_param(data)
    end,
  }
end

return {
  name = 'Go',
  method = null_ls.methods.CODE_ACTION,
  filetypes = { 'go' },
  generator = {
    fn = function()
      return vim.iter({
        split_struct_action(),
        remove_return_parameter_action(),
      }):filter(function(e)
        return e ~= nil
      end):totable()
    end,
  },
}
