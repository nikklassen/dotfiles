if vim.env.NVIM_ENABLE_AVANTE ~= '1' then
  return {}
end

return {
  {
    'Kaiser-Yang/blink-cmp-avante',
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
      provider = 'gemini-cli',
      acp_providers = {
        ['gemini-cli'] = {
          command = 'gemini',
          args = { '--experimental-acp' },
          env = {
            HOME = vim.env.HOME,
            NODE_NO_WARNINGS = '1',
            GOOGLE_CLOUD_PROJECT = '',
          },
          auth_method = 'oauth-personal',
          timeout = 10000,
        },
      },
      vendors = {},
      file_selector = {
        provider = 'telescope',
        provider_opts = {},
      },
    },
  }
}
