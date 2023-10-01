local utils = require 'nikklassen.utils'

local M = {
    _has_proximity_sort = nil
}

function M.directory_files(opts)
    local dir = vim.fn.expand('%:h')
    opts = opts or {}
    local file_opts = vim.tbl_deep_extend('keep', {}, opts, {
        cwd = dir,
        path_display = { tail = true },
    })
    opts = vim.tbl_deep_extend('keep', {}, opts, {
        entry_maker = require 'telescope.make_entry'.gen_from_file(file_opts),
        cwd = dir,
    })
    require 'telescope.pickers'.new(opts, {
        prompt_title = 'directory files',
        finder = require 'telescope.finders'.new_oneshot_job({ 'fd', '-t', 'f', '-d', '1' }, opts),
        sorter = require 'telescope.config'.values.file_sorter(opts),
    }):find()
end

local function fzf_executable()
    if M._has_proximity_sort == nil then
        M._has_proximity_sort = vim.fn.executable('proximity-sort') == 1
        if not M._has_proximity_sort then
            vim.notify('proximity-sort not found, falling back', vim.log.levels.WARN, nil)
        end
    end
    if not M._has_proximity_sort then
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

function M.files(opts)
    opts = opts or {}
    opts.find_command = opts.find_command or fzf_executable()
    -- Same as tiebreak=index
    opts.tiebreak = function() return false end
    require 'telescope.builtin'.find_files(opts)
end

return M
