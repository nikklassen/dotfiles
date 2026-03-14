if vim.env.NVIM_ENABLE_COPILOT ~= '1' then
  return
end

vim.pack.add({
  'https://github.com/zbirenbaum/copilot.lua',
})
require('copilot').setup {
  suggestion = { enabled = false, auto_trigger = false },
  panel = { enabled = false },
  filetypes = {
    oil = false,
  },
}
