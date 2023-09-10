local telescope = require 'telescope'
local pickers = require 'telescope.pickers'
local finders = require 'telescope.finders'
local conf = require('telescope.config').values
local make_entry = require 'telescope.make_entry'
local builtin = require 'telescope.builtin'
local utils = require 'nikklassen.utils'

local function directory_files(opts)
    local dir = vim.fn.expand('%:h')
    opts = opts or {}
    opts = vim.tbl_deep_extend('keep', {}, opts, {
        entry_maker = make_entry.gen_from_file(vim.tbl_deep_extend('keep', {}, opts, {
            cwd = dir,
            path_display = { tail = true },
        })),
        cwd = dir,
    })
    pickers.new(opts, {
        prompt_title = 'directory files',
        finder = finders.new_oneshot_job({ 'fd', '-t', 'f', '-d', '1' }, opts),
        sorter = conf.file_sorter(opts),
    }):find()
end

local has_proximity_sort

local function fzf_executable()
    if has_proximity_sort == nil then
        has_proximity_sort = vim.fn.executable('proximity-sort') == 1
        if not has_proximity_sort then
            vim.notify('proximity-sort not found, falling back', vim.log.levels.WARN, nil)
        end
    end
    if not has_proximity_sort then
        return utils.string_split(vim.env.FZF_DEFAULT_COMMAND)
    end
    local f = vim.fn.expand('%')
    --- @cast f string
    if f == '' then
        f = vim.fn.getcwd()
    end
    local cmd = vim.env.FZF_DEFAULT_COMMAND .. ' | proximity-sort ' .. f
    return { 'sh', '-c', cmd }
end

local function files(opts)
    opts = opts or {}
    opts.find_command = opts.find_command or fzf_executable()
    -- Same as tiebreak=index
    opts.tiebreak = function() return false end
    require('telescope.builtin').find_files(opts)
end

return {
    setup = function(_, opts)
        telescope.setup(opts)
        telescope.load_extension('fzf')

        local km_opts = { silent = true }
        vim.keymap.set('n', '<c-p>', files, km_opts)
        vim.keymap.set('n', '<c-s-p>', builtin.commands, km_opts)
        vim.keymap.set('n', '<leader>b', builtin.buffers, km_opts)
        vim.keymap.set('n', '<leader>f', builtin.lsp_document_symbols, km_opts)
        vim.keymap.set('n', '<leader>d', directory_files, km_opts)
    end,
}
