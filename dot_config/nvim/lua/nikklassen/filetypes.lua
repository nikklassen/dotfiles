vim.filetype.add({
  extension = {
    gotmpl = 'gotmpl',
    tmpl = 'gotmpl',
  },
})

vim.treesitter.query.add_directive('inject-go-tmpl!', function(_, _, bufnr, _, metadata)
  local fname = vim.fs.basename(vim.api.nvim_buf_get_name(bufnr))
  local _, _, ext, _ = string.find(fname, '.*%.(%a+)(%.%a+)')
  if ext == nil then
    return
  end
  metadata['injection.language'] = ext
end, {})
