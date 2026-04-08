if vim.env.NVIM_PROFILE ~= '1' then
  return
end

vim.pack.add({
  'https://github.com/dstein64/vim-startuptime',
  'https://github.com/folke/snacks.nvim',
})

local snacks = require('snacks')
snacks.setup {
  profiler = {
    enabled = true
  }
}

-- Toggle the profiler
snacks.toggle.profiler():map('<leader>pp')
-- Toggle the profiler highlights
snacks.toggle.profiler_highlights():map('<leader>ph')

vim.keymap.set('n', '<leader>ps', function()
  snacks.profiler.scratch()
end)
