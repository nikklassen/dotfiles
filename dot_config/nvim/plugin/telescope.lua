local telescope = require('telescope')
local builtin = require('telescope.builtin')
local previewers = require('telescope.previewers')
local pickers = require('telescope.pickers')
local sorters = require('telescope.sorters')
local finders = require('telescope.finders')
local nikklassen_telescope = require('nikklassen.telescope')

telescope.setup {
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
}
telescope.load_extension('fzf')
telescope.load_extension('ui-select')

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

vim.keymap.set('n', '<c-p>', nikklassen_telescope.files)
vim.keymap.set('n', '<c-s-p>', builtin.commands)
vim.keymap.set('n', '<leader>b', function()
  builtin.buffers {
    sort_mru = true,
    ignore_current_buffer = true,
    path_display = { 'truncate' },
  }
end)
vim.keymap.set('n', '<leader>f', function()
  builtin.lsp_document_symbols {
    symbols = 'function'
  }
end)
vim.keymap.set('n', '<leader>gf', vcs_files)
vim.keymap.set('n', 'grr', lsp_references)
vim.keymap.set('n', '<leader>d', nikklassen_telescope.directory_files)
vim.keymap.set('n', '<c-t>', builtin.lsp_dynamic_workspace_symbols)
