vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
    tmpl = 'gotmpl',
  },
})

local function get_ext(fname, bufnr)
  local _, _, ext, _ = string.find(fname, '.*%.(%a+)(%.%a+)')
  if ext ~= nil then
    return ext
  end

  local first_line_tbl = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
  if first_line_tbl and #first_line_tbl > 0 then
    if first_line_tbl[1] == '#!/bin/zsh' then
      return 'zsh'
    elseif first_line_tbl[1] == '#!/bin/bash' then
    end
  end

  return nil
end

local function get_lang(bufnr)
  local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
  if string.match(fname, '^%..*ignore(.tmpl)$') then
    return 'gitignore'
  end
  local ext = get_ext(fname, bufnr)
  if ext == nil then
    return
  end
  if ext == 'tf' then
    return 'terraform'
  end
  return ext
end

vim.treesitter.query.add_directive('inject-go-tmpl!', function(_, _, bufnr, _, metadata)
  local lang = get_lang(bufnr)
  if lang == nil then
    return
  end
  metadata['injection.language'] = lang
end, {})
