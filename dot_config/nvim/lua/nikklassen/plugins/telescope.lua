local utils = require 'nikklassen.utils'

local builtin = utils.lazy_require('telescope.builtin')
local previewers = utils.lazy_require('telescope.previewers')
local pickers = utils.lazy_require('telescope.pickers')
local sorters = utils.lazy_require('telescope.sorters')
local finders = utils.lazy_require('telescope.finders')
local nikklassen_telescope = utils.lazy_require('nikklassen.telescope')

local function lsp_references()
  builtin.lsp_references { show_line = false }
end

local function jj_files(opts)
  pickers
      .new(opts, {
        results_title = 'Modified in current branch',
        finder = finders.new_oneshot_job({ 'sh', '-c', 'jj diff -s | sed -n "/^[MA] / s///p"' }, {
          entry_maker = nikklassen_telescope.vs_code_path_transform(opts),
        }),
        sorter = sorters.get_fuzzy_file(),
        previewer = previewers.new_termopen_previewer({
          get_command = function(entry)
            return {
              'jj',
              'diff',
              '--git',
              '--no-pager',
              entry.value,
            }
          end,
        }),
      })
      :find()
end

local function hg_files(opts)
  pickers
      .new(opts, {
        results_title = 'Modified in current branch',
        finder = finders.new_oneshot_job({ 'sh', '-c', 'hg status | sed -n "/^[MA] / s///p"' }, {
          entry_maker = nikklassen_telescope.vs_code_path_transform(opts),
        }),
        sorter = sorters.get_fuzzy_file(),
        previewer = previewers.new_termopen_previewer({
          get_command = function(entry)
            return {
              'hg',
              'diff',
              '--git',
              entry.value,
            }
          end,
        }),
      })
      :find()
end

local function vcs_files(opts)
  opts = opts or {}
  local dirs = vim.fs.find({ '.jj', '.hg' }, {
    limit = 1,
    upward = true,
  })
  for _, dir in ipairs(dirs) do
    if string.match(dir, '.*%.jj$') then
      jj_files(opts)
      return
    elseif string.match(dir, '.*%.hg$') then
      hg_files(opts)
      return
    end
  end
  builtin.git_files()
end

return {
  {
    'nvim-telescope/telescope.nvim',
    -- No new releases since 2024, but fixes exist on master
    -- branch = '0.1.x',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
      'nvim-telescope/telescope-ui-select.nvim',
    },
    opts = {
      defaults = {
        layout_strategy = 'vertical',
        mappings = {
          i = {
            ['<esc>'] = 'close',
            ['<C-a>'] = { '<Home>', type = 'command' },
            ['<C-e>'] = { '<End>', type = 'command' },
            ['<C-o>'] = { '<esc>', type = 'command', opts = { remap = false } },
          },
        },
      },
    },
    keys = function(_, keys)
      return utils.merge_keys('keep', keys or {}, {
        { '<c-p>',   nikklassen_telescope.files },
        { '<c-s-p>', builtin.commands },
        { '<leader>b', function()
          builtin.buffers {
            sort_mru = true,
            ignore_current_buffer = true,
            path_display = { 'truncate' },
          }
        end },
        { '<leader>f', function()
          builtin.lsp_document_symbols {
            symbols = 'function'
          }
        end },
        { '<leader>gf', vcs_files },
        { '<S-F12>',    lsp_references },
        { '<F24>',      lsp_references },
        { '<leader>d',  utils.lazy_require('nikklassen.telescope').directory_files },
        { '<C-T>',      builtin.lsp_dynamic_workspace_symbols },
      })
    end,
    config = function(_, opts)
      local telescope = require 'telescope'
      telescope.setup(opts)
      -- telescope.load_extension('fzf')
      telescope.load_extension('ui-select')
    end
  },
}
