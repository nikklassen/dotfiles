local parsers = require'nvim-treesitter.parsers'
local queries = require'nvim-treesitter.query'
local tsutils = require'nvim-treesitter.ts_utils'

local M = {}

local function toggle_with_filter(bufnr, lang, query, pred)
  bufnr = bufnr or vim.api.nvim_get_current_buf()
  lang = lang or parsers.get_buf_lang(bufnr)

  local curs = vim.api.nvim_win_get_cursor(0)

  local matches = queries.get_capture_matches(bufnr, query, 'bulk_folds')
  local open_fold
  for _, m in ipairs(matches) do
    if pred(bufnr, m.node) then
      local sl, _, _, _ = m.node:range()
      local vim_linenr = sl+1
      if open_fold == nil then
        open_fold = vim.fn.foldclosed(vim_linenr) ~= -1
      end
      if open_fold then
        vim.cmd(vim_linenr .. 'normal! zO')
      else
        vim.cmd(vim_linenr .. 'normal! zC')
      end
    end
  end

  vim.api.nvim_win_set_cursor(0, curs)
end

function M.toggle_type_folds(bufnr, lang, typ)
  toggle_with_filter(bufnr, lang, '@bulk_folds.method_receivers', function(pbufnr, node)
    local receiver = tsutils.get_node_text(node, pbufnr)[1]
    return receiver == typ
  end)
end

function M.toggle_by_query(bufnr, lang, query)
  toggle_with_filter(bufnr, lang, query, function(_, _) return true end)
end

function M.attach(bufnr, lang)
  vim.cmd(string.format([[command! -buffer FoldTypeMethods lua require'nikklassen.bulk-folds'.toggle_type_folds(%d, '%s', vim.fn.expand('<cword>'))]], bufnr, lang))
  vim.cmd(string.format([[command! -buffer FoldTests lua require'nikklassen.bulk-folds'.toggle_by_query(%d, '%s', '@bulk_folds.test_functions')]], bufnr, lang))
  vim.cmd(string.format([[command! -buffer FoldMethods lua require'nikklassen.bulk-folds'.toggle_by_query(%d, '%s', '@bulk_folds.methods')]], bufnr, lang))
  vim.cmd(string.format([[command! -buffer FoldFunctions lua require'nikklassen.bulk-folds'.toggle_by_query(%d, '%s', '@bulk_folds.functions')]], bufnr, lang))
end

function M.detach() end

return M
