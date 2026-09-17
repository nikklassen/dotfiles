local comments = require('nikklassen.comments')

vim.api.nvim_create_user_command('Comment', comments.add, {
  desc = 'Add or edit a comment on the current line',
})

vim.api.nvim_create_user_command('CommentDelete', comments.delete, {
  desc = 'Delete the comment on the current line',
})

vim.api.nvim_create_user_command('CommentList', comments.list, {
  desc = 'Put all comments in the quickfix list',
})

vim.api.nvim_create_user_command('CommentCopy', function(args)
  comments.copy(args.bang)
end, {
  bang = true,
  desc = 'Copy all comments as <path>:<line>:<text>, clearing them with !',
})

vim.api.nvim_create_user_command('CommentClear', comments.clear, {
  desc = 'Delete all comments',
})

local group = vim.api.nvim_create_augroup('nikklassen.comments', {})
vim.api.nvim_create_autocmd('BufReadPost', {
  group = group,
  callback = function(args)
    comments.on_buf_read(args.buf)
  end,
})
vim.api.nvim_create_autocmd('BufUnload', {
  group = group,
  callback = function(args)
    comments.on_buf_unload(args.buf)
  end,
})

local opts = { silent = true }
vim.keymap.set('n', '<leader>ca', comments.add, opts)
vim.keymap.set('n', '<leader>cd', comments.delete, opts)
vim.keymap.set('n', '<leader>cl', comments.list, opts)
vim.keymap.set('n', '<leader>cy', '<cmd>CommentCopy!<cr>', opts)
