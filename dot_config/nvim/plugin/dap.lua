local dap = require('dap')

local dapui = require('dapui')
require('dapui').setup()

vim.keymap.set('n', '<S-F1>', function()
  dap.hover(vim.fn.input('Expression: '))
end)
vim.keymap.set('n', '<F5>', dap.continue)
-- Shift F5
vim.keymap.set('n', '<F17>', function()
  require('dapui').close()
  dap.close()
end)
vim.keymap.set('n', '<F9>', dap.toggle_breakpoint)
vim.keymap.set('n', '<F10>', dap.step_over)
vim.keymap.set('n', '<F11>', dap.step_into)
-- Shift F11
vim.keymap.set('n', '<F23>', dap.step_out)

vim.api.nvim_create_user_command('DBG', function()
  dapui.toggle()
end, {})

-- Stop sign with a square in it, nf-cod-stop_circle
vim.fn.sign_define('DapBreakpoint', { text = '\u{eba5}', texthl = 'Error' })

vim.api.nvim_create_user_command('DapBreakCondition', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { force = true })
vim.api.nvim_create_user_command('DapBreakLog', function()
  dap.set_breakpoint(vim.fn.input(nil, nil, vim.fn.input('Log point message: ')))
end, { force = true })

vim.api.nvim_create_autocmd('FileType', {
  pattern = 'go',
  callback = function()
    require('dap-go').setup()
  end,
})
