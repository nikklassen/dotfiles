if vim.env.NVIM_DISABLE_COPILOT == '1' then
  return {}
end

return {
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    main = 'copilot',
    opts = {
      suggestion = { enabled = false, auto_trigger = false },
      panel = { enabled = false },
    },
  },
  {
    'saghen/blink.cmp',
    dependencies = {
      {
        'fang2hou/blink-copilot',
        opts = {
          max_completions = 1,
          max_attempts = 2,
        },
      },
    },
    opts = {
      sources = {
        default = { 'copilot' },
        providers = {
          copilot = {
            name = 'copilot',
            module = 'blink-copilot',
            score_offset = 100,
            async = true,
          }
        }
      }
    },
    opts_extend = { 'sources.default' }
  },
}
