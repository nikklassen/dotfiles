return {
  {
    'mfussenegger/nvim-dap',
    cmd = { 'DBG' },
    keys = { '<F9>', '<F5>', '<S-F5>' },
    dependencies = {
      {
        'leoluz/nvim-dap-go',
        ft = { 'go' },
        main = 'dap-go',
        config = true,
      },
      {
        'rcarriga/nvim-dap-ui',
        dependencies = {
          { "nvim-neotest/nvim-nio" },
        },
        config = function()
          local dapui = require 'dapui'
          local dap = require 'dap'
          dapui.setup()

          -- Stop sign with a square in it, nf-cod-stop_circle
          vim.fn.sign_define('DapBreakpoint', { text = '\u{eba5}', texthl = 'Error' })

          vim.api.nvim_create_user_command('DBG', dapui.toggle, { force = true })

          vim.api.nvim_create_user_command('DapBreakCondition', function()
            dap.set_breakpoint(vim.fn.input('Breakpoint condition: '))
          end, { force = true })
          vim.api.nvim_create_user_command('DapBreakLog', function()
            dap.set_breakpoint(vim.fn.input(nil, nil, vim.fn.input('Log point message: ')))
          end, { force = true })

          vim.keymap.set('n', '<S-F1>', function()
            dap.hover(vim.fn.input('Expression: '))
          end)
          vim.keymap.set('n', '<F5>', dap.continue)
          -- <S-F5>
          vim.keymap.set('n', '<F17>', function()
            dapui.close()
            dap.close()
          end)
          vim.keymap.set('n', '<F9>', dap.toggle_breakpoint)
          vim.keymap.set('n', '<F10>', dap.step_over)
          vim.keymap.set('n', '<F11>', dap.step_into)
          -- <S-F11>
          vim.keymap.set('n', '<F23>', dap.step_out)
        end,
      },
    },
  },
}
