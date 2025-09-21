vim.lsp.enable('svelte')

vim.api.nvim_create_autocmd('BufWritePost', {
  pattern = { '*.js', '*.ts' },
  group = vim.api.nvim_create_augroup('svelte_ondidchangetsorjsfile', { clear = true }),
  callback = function(ctx)
    local clients = vim.lsp.get_clients({
      name = 'svelte',
      bufnr = ctx.buf,
    })
    if #clients < 1 then
      return
    end
    local notification = '$/onDidChangeTsOrJsFile'
    ---@cast notification vim.lsp.protocol.Method.ClientToServer.Notification
    -- Here use ctx.match instead of ctx.file
    clients[1]:notify(notification, { uri = ctx.match })
  end,
})
