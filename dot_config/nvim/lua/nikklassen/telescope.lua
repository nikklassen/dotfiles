local utils = require 'nikklassen.utils'
local devicons = utils.lazy_require('nvim-web-devicons')

local M = {
  _has_proximity_sort = nil
}

local function make_displayer()
  local entry_display = require('telescope.pickers.entry_display')
  local default_icons, _ = devicons.get_icon('file', '', { default = true })

  local displayer = entry_display.create {
    separator = ' ',
    items = {
      { width = vim.fn.strwidth(default_icons) },
      {},
      { remaining = true },
    },
  }

  return function(entry)
    return displayer {
      { entry.devicons, entry.devicons_highlight },
      entry.file_name,
      { entry.dir_name, 'Comment' }
    }
  end
end

-- Based on https://github.com/nvim-telescope/telescope.nvim/wiki/Configuration-Recipes#customize-buffers-display-to-look-like-leaderf
function M.vs_code_path_transform(_opts)
  return function(entry)
    local bufname = entry ~= '' and entry or '[No Name]'

    local dir_name = vim.fn.fnamemodify(bufname, ':p:.:h')
    local file_name = vim.fn.fnamemodify(bufname, ':p:t')

    local icons, highlight = devicons.get_icon(bufname, string.match(bufname, '%a+$'), { default = true })

    return {
      valid = true,
      value = bufname,
      ordinal = file_name,
      display = make_displayer(),
      devicons = icons,
      devicons_highlight = highlight,
      file_name = file_name,
      dir_name = dir_name,
    }
  end
end

function M.directory_files(opts)
  opts = opts or {}
  local dir = opts.cwd or vim.fn.expand('%:h')
  -- Keep a copy of the original opts for the recursive call.
  local original_opts = vim.deepcopy(opts)

  local file_opts = vim.tbl_deep_extend('keep', {}, opts, {
    cwd = dir,
    path_display = { tail = true },
  })
  opts = vim.tbl_deep_extend('keep', {}, opts, {
    entry_maker = require 'telescope.make_entry'.gen_from_file(file_opts),
    cwd = dir,
    attach_mappings = function(prompt_bufnr, map)
      local actions = require 'telescope.actions'
      local action_state = require 'telescope.actions.state'
      map('i', '<C-u>', function()
        local picker = action_state.get_current_picker(prompt_bufnr)
        local parent_dir = vim.fn.fnamemodify(picker.cwd, ':h')
        actions.close(prompt_bufnr)
        original_opts.cwd = parent_dir
        M.directory_files(original_opts)
      end)
      return true
    end,
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
    return utils.string_split(vim.env.FZF_DEFAULT_COMMAND or '')
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
