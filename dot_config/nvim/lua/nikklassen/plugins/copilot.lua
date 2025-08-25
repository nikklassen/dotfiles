if vim.env.NVIM_DISABLE_COPILOT == '1' then
  return {}
end

local plugins = {
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
}

if vim.fn.has('nvim-0.12.0') then
  vim.list_extend(plugins, {
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
  })
end

return plugins
