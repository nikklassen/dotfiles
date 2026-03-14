vim.api.nvim_create_autocmd('PackChanged', {
  callback = function(ev)
    local name, kind = ev.data.spec.name, ev.data.kind
    if name == 'telescope-fzf-native.nvim' and (kind == 'install' or kind == 'update') then
      vim.system({ 'make' }, { cwd = ev.data.path })
    end
    if name == 'nvim-treesitter' and kind == 'update' then
      if not ev.data.active then
        vim.cmd.packadd('nvim-treesitter')
      end
      vim.cmd('TSUpdate')
    end
  end
})

vim.pack.add({
  -- Shared dependencies
  -- hardtime, codediff, and hunk
  'https://github.com/MunifTanjim/nui.nvim',
  'https://github.com/nvim-lua/plenary.nvim',

  -- 'https://github.com/dstein64/vim-startuptime',

  'https://github.com/tpope/vim-sensible',
  'https://github.com/tpope/vim-abolish',
  'https://github.com/whiteinge/diffconflicts',
  'https://github.com/echasnovski/mini.operators',
  'https://github.com/tpope/vim-eunuch',
  'https://github.com/rcarriga/nvim-notify',
  'https://github.com/gregorias/coop.nvim',
  'https://github.com/phelipetls/jsonpath.nvim',
  'https://github.com/folke/flash.nvim',
  'https://github.com/m4xshen/hardtime.nvim',
  'https://github.com/julienvincent/hunk.nvim',
  'https://github.com/windwp/nvim-autopairs',
  'https://github.com/windwp/nvim-ts-autotag',
  'https://github.com/nvimtools/none-ls.nvim',
  'https://github.com/rgroli/other.nvim',
  'https://github.com/nvim-tree/nvim-web-devicons',
  {
    src = 'https://github.com/esmuellert/codediff.nvim',
    version = vim.version.range('2.*')
  },
  {
    src = 'https://github.com/saghen/blink.cmp',
    version = vim.version.range('1.*'),
  },
  {
    src = 'https://github.com/stevearc/oil.nvim',
    version = vim.version.range('*'),
  },
  {
    src = 'https://github.com/navarasu/onedark.nvim',
    version = vim.version.range('*'),
  },
  {
    src = 'https://github.com/neovim/nvim-lspconfig',
    version = vim.version.range('2.*'),
  },
  {
    src = 'https://github.com/kylechui/nvim-surround',
    version = vim.version.range('4.*'),
  },

  -- DAP
  'https://github.com/mfussenegger/nvim-dap',
  'https://github.com/nvim-neotest/nvim-nio',
  'https://github.com/rcarriga/nvim-dap-ui',
  'https://github.com/leoluz/nvim-dap-go',

  -- Telescope
  {
    src = 'https://github.com/nvim-telescope/telescope.nvim',
    version = vim.version.range('0.2.*'),
  },
  'https://github.com/nvim-telescope/telescope-fzf-native.nvim',
  'https://github.com/nvim-telescope/telescope-ui-select.nvim',

  -- Treesitter
  'https://github.com/nvim-treesitter/nvim-treesitter',
  'https://github.com/nvim-treesitter/nvim-treesitter-context',
  'https://github.com/nvim-treesitter/nvim-treesitter-textobjects',
})

vim.schedule(function()
  vim.pack.add({ 'https://github.com/mhinz/vim-signify' })
  vim.g.signify_number_highlight = 1
  vim.g.signify_sign_change = '~'
end)

-- Abolish provides the :S command, and case coercion
vim.g.abolish_no_mappings = 1

require('mini.operators').setup {
  replace = {
    prefix = 'cr',
  },
}

vim.g.eunuch_no_maps = true

local notify = require('notify')
vim.notify = notify

require('notify').setup {
  timeout = 3000,
  render = 'compact',
  stages = 'fade',
  top_down = false,
}

require('oil').setup {
  keymaps = {
    ['<C-s>'] = false,
    ['<C-v>'] = { 'actions.select', opts = { vertical = true } },
  }
}
vim.keymap.set('n', '<leader>o', function()
  local oil = require 'oil'
  local current_dir = vim.fn.expand('%:h')
  oil.open(current_dir)
end, { desc = "Edit current file's directory with oil" })

-- Onedark
local onedark = require 'onedark'
onedark.setup()
onedark.load()

require('nikklassen.yank').setup()
