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
      {
        "zbirenbaum/copilot-cmp",
        event = 'LspAttach',
        cond = function()
          return vim.env.NVIM_DISABLE_COPILOT ~= '1'
        end,
        config = function()
          local copilot_cmp = require('copilot_cmp')
          copilot_cmp.setup {}
          vim.api.nvim_create_autocmd("LspAttach", {
            callback = function(args)
              local client = vim.lsp.get_client_by_id(args.data.client_id)
              if client.name == "copilot" then
                copilot_cmp._on_insert_enter({})
              end
            end,
          })
          vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6CC644" })
        end,
        dependencies = {
          {
            "zbirenbaum/copilot.lua",
            cmd = "Copilot",
            cond = function()
              return vim.env.NVIM_DISABLE_COPILOT ~= '1'
            end,
            event = "InsertEnter",
            main = 'copilot',
            opts = {
              suggestion = { enabled = true, auto_trigger = false },
              panel = { enabled = false },
            },
          },
        },
      },
    },
  },
}
