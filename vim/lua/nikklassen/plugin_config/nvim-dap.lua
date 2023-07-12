local dapui = require 'dapui'
local dap = require 'dap'

local M = {}

function M.configure()
    dapui.setup()

    -- Stop sign with a square in it, nf-cod-stop_circle
    vim.fn.sign_define('DapBreakpoint', { text = '\u{eba5}', texthl = 'Error' })

    dap.adapters.delve = {
        type = "server",
        port = "${port}",
        executable = {
            command = 'dlv',
            args = { 'dap', '-l', '127.0.0.1:${port}', '--check-go-version=false' },
        },
        initialize_timeout_sec = 10,
    }

    vim.api.nvim_create_user_command('DBG', dapui.toggle, { force = true })

    -- Optional configure key bindings:
    -- vim.cmd([[ nnoremap <silent> <Leader>B <Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR> ]])
    -- vim.cmd([[ nnoremap <silent> <Leader>lp <Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR> ]])
    -- vim.cmd([[ nnoremap <silent> <Leader>dr <Cmd>lua require'dap'.repl.open()<CR> ]])
    -- vim.cmd([[ nnoremap <silent> <Leader>dl <Cmd>lua require'dap'.run_last()<CR> ]])

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
end

return M
