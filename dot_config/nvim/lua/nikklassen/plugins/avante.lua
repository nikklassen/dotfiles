if vim.env.NVIM_DISABLE_COPILOT == '1' and vim.env.NVIM_ENABLE_AVANTE ~= '1' then
  return {}
end

return {
  {
    'Kaiser-Yang/blink-cmp-avante',
    lazy = true,
  },
  {
    'stevearc/dressing.nvim',
    lazy = true,
  },
  {
    'saghen/blink.cmp',
    opts = {
      sources = {
        default = { 'avante' },
        providers = {
          avante = {
            name = 'Avante',
            module = 'blink-cmp-avante',
            score_offset = 90,
            opts = {},
          },
        },
      },
    },
  },
  {
    'yetone/avante.nvim',
    keys = {
      '<leader>aa',
      '<leader>ae',
    },
    version = false,
    build = 'make',
    opts = {
      provider = 'copilot',
      providers = {
        ollama = {
          -- model = 'qwq:32b',
          model = 'codeqwen:7b-chat',
        },
      },
      -- cursor_applying_provider = 'ollama',
      behaviour = {
        enable_cursor_planning_mode = true,
      },
      vendors = {},
      file_selector = {
        provider = 'telescope',
        provider_opts = {},
      },
    },
  }
}
