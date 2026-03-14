require('hunk').setup {
  keys = {
    global = {
      -- "hunk accept"
      accept = { '<leader>ha' },
    },
    tree = {
      toggle_file = { '<Space>' }
    },
    diff = {
      toggle_line = { '<Space>' }
    }
  },
  hooks = {
    on_tree_mount = function()
      vim.bo.ft = 'hunk'
    end,
    on_diff_mount = function(context)
      vim.keymap.set('n', '<Up>', '[c', {
        buffer = context.buf
      })
      vim.keymap.set('n', '<Down>', ']c', {
        buffer = context.buf
      })
      vim.cmd('normal ]c')
    end,
  },
}
