return {
  {
    'hrsh7th/nvim-cmp',
    enabled = false,
    branch = 'main',
    event = 'InsertEnter',
    opts = {},
    main = 'nikklassen.plugin_config.nvim-cmp',
    dependencies = {
      {
        'hrsh7th/cmp-nvim-lsp',
        branch = 'main',
      },
      'ray-x/lsp_signature.nvim',
      'onsails/lspkind.nvim',
    },
  },
}
