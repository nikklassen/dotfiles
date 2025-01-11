local function setup()
  local copilot_cmp = require('copilot_cmp')
  copilot_cmp.setup()
  vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
end

if vim.env.NVIM_DISABLE_COPILOT == '1' then
  return {}
end

return {
  {
    "zbirenbaum/copilot-cmp",
    config = setup,
    dependencies = {
      {
        "zbirenbaum/copilot.lua",
        cmd = "Copilot",
        main = 'copilot',
        opts = {
          suggestion = { enabled = true, auto_trigger = false },
          panel = { enabled = false },
        },
      },
    },
  },
  {
    'saghen/blink.cmp',
    opts = {
      sources = {
        default = { 'copilot' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink.compat.source',
          }
        }
      }
    },
    opts_extend = { 'sources.default' }
  }
}
