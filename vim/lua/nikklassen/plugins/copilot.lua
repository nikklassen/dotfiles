if vim.env.NVIM_DISABLE_COPILOT == '1' then
  return {}
end

return {
  {
    'zbirenbaum/copilot.lua',
    cmd = 'Copilot',
    event = { 'InsertEnter' },
    main = 'copilot',
    opts = {
      suggestion = { enabled = false, auto_trigger = false },
      panel = { enabled = false },
    },
  },
  {
    'fang2hou/blink-copilot',
    lazy = true,
    opts = {
      max_completions = 1,
      max_attempts = 2,
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
