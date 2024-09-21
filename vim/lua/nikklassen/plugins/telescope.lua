local utils = require 'nikklassen.utils'

local function lsp_references()
  require('telescope.builtin').lsp_references { show_line = false }
end

local function vcs_files()
  if vim.tbl_isempty(vim.fs.find('.jj', { upward = true })) then
    require("telescope.builtin").git_files()
    return
  end
  local previewers = require("telescope.previewers")
  local pickers = require("telescope.pickers")
  local sorters = require("telescope.sorters")
  local finders = require("telescope.finders")
  pickers
      .new({}, {
        results_title = "Modified in current branch",
        finder = finders.new_oneshot_job({ 'sh', '-c', 'jj diff -s | sed -n "/^[MA] / s///p"' }, {}),
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

return {
  {
    'nvim-telescope/telescope.nvim',
    branch = '0.1.x',
    dependencies = {
      { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
    },
    opts = {
      defaults = {
        layout_strategy = 'vertical',
        mappings = {
          i = {
            ["<esc>"] = 'close',
            ["<C-a>"] = { '<Home>', type = 'command' },
            ["<C-e>"] = { '<End>', type = 'command' }
          },
        },
      },
    },
    keys = function(_, keys)
      return utils.merge_keys('keep', keys or {}, {
        { '<c-p>',   utils.lazy_require('nikklassen.telescope').files },
        { '<c-s-p>', utils.lazy_require('telescope.builtin').commands },
        { '<leader>b', function()
          require('telescope.builtin').buffers {
            sort_mru = true,
            ignore_current_buffer = true,
            path_display = { 'truncate' },
          }
        end },
        { '<leader>f', function()
          require('telescope.builtin').lsp_document_symbols {
            symbols = 'function'
          }
        end },
        { '<leader>gf', vcs_files },
        { '<S-F12>',    lsp_references },
        { '<F24>',      lsp_references },
        { '<leader>d',  utils.lazy_require('nikklassen.telescope').directory_files },
      })
    end,
    config = function(_, opts)
      local telescope = require 'telescope'
      telescope.setup(opts)
      telescope.load_extension('fzf')
    end
  },
}
