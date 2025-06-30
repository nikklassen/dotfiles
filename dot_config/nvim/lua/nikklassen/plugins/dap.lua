local nk_utils = require('nikklassen.utils')

local dap = nk_utils.lazy_require('dap')
local dapui = nk_utils.lazy_require('dapui')

-- Stop sign with a square in it, nf-cod-stop_circle
vim.fn.sign_define('DapBreakpoint', { text = '\u{eba5}', texthl = 'Error' })

vim.api.nvim_create_user_command('DBG', dapui.toggle, { force = true })

vim.api.nvim_create_user_command('DapBreakCondition', function()
  dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
end, { force = true })
vim.api.nvim_create_user_command('DapBreakLog', function()
  dap.set_breakpoint(vim.fn.input(nil, nil, vim.fn.input('Log point message: ')))
end, { force = true })

return {
  {
    'leoluz/nvim-dap-go',
    ft = { 'go' },
    main = 'dap-go',
    opts = {},
    lazy = true,
  },
  {
    'mfussenegger/nvim-dap',
    main = 'dap',
    cmd = { 'DBG' },
    keys = {
      { '<S-F1>', function()
        dap.hover(vim.fn.input('Expression: '))
      end },
      { '<F5>',  dap.continue },
      { '<F9>',  dap.toggle_breakpoint },
      { '<F10>', dap.step_over },
      { '<F11>', dap.step_into },
      -- Shift F11
      { '<F23>', dap.step_out },
    },
  },
  {
    'nvim-neotest/nvim-nio',
    lazy = true,
  },
  {
    'rcarriga/nvim-dap-ui',
    main = 'dapui',
    cmd = {
      'DBG',
    },
    keys = {
      -- <S-F5>
      { '<F17>', function()
        dapui.close()
        dap.close()
      end },
    },
    opts = {},
  },
}
