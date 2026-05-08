local ts = require('nikklassen.lsp.treesitter')

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

local function children_of_type(node, type)
  local results = {}
  for child in node:iter_children() do
    if child:type() == type then
      results[#results + 1] = child
    end
  end
  return results
end

---@param bufnr number
---@param node TSNode
---@return lsp.CodeAction?
local function split_struct_action(bufnr, node)
  local comp_literal = find_ancestor(node, 'composite_literal')
  if not comp_literal then return nil end

  local sr, sc, er, ec = comp_literal:range()
  if sr ~= er then
    return nil -- Already multi-line
  end

  local literals = children_of_type(comp_literal, 'literal_value')
  if #literals == 0 then return nil end
  local literal_value = literals[1]

  local current_line = vim.api.nvim_buf_get_lines(bufnr, sr, sr + 1, false)[1]
  local line_prefix = current_line:sub(1, sc)
  local indent = current_line:match('^%s*')
  local shiftwidth = vim.bo[bufnr].shiftwidth
  local expandtab = vim.bo[bufnr].expandtab
  local inner_indent = indent .. (expandtab and string.rep(' ', shiftwidth) or '\t')

  local type_node = comp_literal:child(0)
  if type_node == nil then return nil end

  local type_text = vim.treesitter.get_node_text(type_node, bufnr)

  local new_lines = { line_prefix .. type_text .. '{' }
  local elements = { '' }

  for child in literal_value:iter_children() do
    local child_text = vim.treesitter.get_node_text(child, bufnr)

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

  return {
    title = 'Split struct literal',
    kind = 'refactor.rewrite',
    edit = {
      changes = {
        [vim.uri_from_bufnr(bufnr)] = {
          {
            range = {
              start = { line = sr, character = 0 },
              ['end'] = { line = sr, character = #current_line },
            },
            newText = table.concat(new_lines, '\n'),
          }
        }
      }
    }
  }
end

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

local function return_param_data(node, line, col)
  local func_decl = find_ancestor(node, 'function_declaration') or find_ancestor(node, 'method_declaration')
  if not func_decl then return nil end

  local result_fields = func_decl:field('result')
  if #result_fields == 0 then return nil end

  local results = result_fields[1]

  local rsr, rsc, rer, rec = results:range()
  if not (line >= rsr and line <= rer and (line ~= rsr or col >= rsc) and (line ~= rer or col <= rec)) then
    return nil
  end

  local decl = find_ancestor(node, 'parameter_declaration')
  if not decl then
    return nil
  end

  local param_index = nil
  for i, child in ipairs(children_of_type(results, 'parameter_declaration')) do
    if child == decl then
      param_index = i
      break
    end
  end

  if not param_index then return nil end

  return {
    idx = param_index,
    results = results,
    func = func_decl,
  }
end

---@param bufnr number
---@param node TSNode
---@param line number
---@param col number
---@return lsp.CodeAction?
local function remove_return_parameter_action(bufnr, node, line, col)
  local data = return_param_data(node, line, col)
  if not data then return nil end

  local changes = {}
  local param_index = data.idx
  local results = data.results
  local func_decl = data.func

  local result_params = children_of_type(results, 'parameter_declaration')

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

  local body = func_decl:field('body')
  if #body > 0 then
    local body_changes = remove_return_param_from_body(body[1], param_index)
    vim.list_extend(changes, body_changes)
  end

  return {
    title = 'Remove return parameter',
    kind = 'refactor.rewrite',
    edit = {
      changes = {
        [vim.uri_from_bufnr(bufnr)] = changes
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

  local tree = ts.parse_buffer(bufnr, 'go')
  if not tree then return {} end
  local line = params.range.start.line
  local col = params.range.start.character
  local node = ts.get_node_at_position(tree, line, col)
  if not node then return {} end

  local split = split_struct_action(bufnr, node)
  if split then table.insert(actions, split) end

  local remove_param = remove_return_parameter_action(bufnr, node, line, col)
  if remove_param then table.insert(actions, remove_param) end

  return actions
end

return M
