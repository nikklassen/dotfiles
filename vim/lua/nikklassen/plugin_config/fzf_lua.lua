local fzf = require 'fzf-lua'

local M = {}

local function files()
    local f = vim.fn.expand('%')
    --- @cast f string
    if f == '' then
        f = vim.fn.getcwd()
    end
    fzf.files({
        cmd = ('%s | proximity-sort "%s"'):format(vim.env.FZF_DEFAULT_COMMAND, f),
        fzf_opts = { ['--tiebreak'] = 'index' },
    })
end

function M.setup()
    local opts = { silent = true }
    vim.keymap.set('n', '<c-p>', files, opts)
    vim.keymap.set('n', '<C-S-P>', fzf.commands, opts)
    vim.keymap.set('n', '<leader>b', fzf.buffers, opts)
    vim.keymap.set('n', '<leader>f', fzf.lsp_document_symbols, opts)
    vim.keymap.set('n', '<leader>d', function()
        local dir = vim.fn.expand('%:h')
        fzf.fzf_exec('fd -t f -d 1', {
            cwd = dir,
            actions = {
                ['default'] = function(selected)
                    vim.cmd('edit ' .. vim.fn.resolve(dir .. '/' .. selected[1]))
                end
            }
        })
    end, opts)

    fzf.setup {
        files = {
            previewer = false,
        },
        buffers = {
            previewer = false,
        },
        commands = {
            actions = { ["default"] = fzf.actions.ex_run_cr },
        }
    }
end

return M
