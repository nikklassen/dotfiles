local fzf = require'fzf-lua'

local M = {}

function M.configure()
    local opts = { silent = true }
    vim.keymap.set('n', '<c-p>', function ()
        fzf.files({
            cmd = ('%s | proximity-sort "%s"'):format(vim.env.FZF_DEFAULT_COMMAND, vim.fn.expand('%')),
            fzf_opts = {['--tiebreak'] = 'index'},
        })
    end, opts)
    vim.keymap.set('n', '<leader>b', function ()
        fzf.buffers()
    end, opts)

    fzf.setup {
        files = {
            previewer = false,
        },
    }
end

return M
