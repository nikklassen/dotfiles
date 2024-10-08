local utils = require('nikklassen.utils')

local function init_luals(client)
  local path = ''
  if client.workspace_folders ~= nil then
    path = client.workspace_folders[1].name
  end
  if utils.uv.fs_stat(path .. '/.luarc.json') or utils.uv.fs_stat(path .. '/.luarc.jsonc') then
    return
  end
  client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
    runtime = {
      version = 'LuaJIT'
    },
    -- Make the server aware of Neovim runtime files
    workspace = {
      checkThirdParty = false,
      library = vim.list_extend({
        vim.env.VIMRUNTIME,
      }, vim.api.nvim_get_runtime_file("", true)),
    },
    completion = {
      callSnippet = "Replace",
    }
  })
end

return {
  {
    'nvim-lua/lsp-status.nvim',
    event = 'LspAttach',
    config = function()
      local lsp_status = require('lsp-status')
      lsp_status.config {
        current_function = false,
        show_filename = false,
        indicator_errors = 'E',
        indicator_warnings = 'W',
        indicator_info = 'i',
        indicator_hint = '?',
        indicator_ok = 'Ok',
        status_symbol = '',
      }
      lsp_status.register_progress()
    end,
  },
  {
    'neovim/nvim-lspconfig',
    event = { 'BufReadPre', 'BufNewFile' },
    opts = {
      debug = false,

      diagnostics = {
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
      },

      servers = {
        gopls = {
          settings = {
            gopls = {
              analyses = {
                unusedparams = true,
              },
              staticcheck = true,
            },
          },
          on_attach = function(client, bufnr)
            require('nikklassen.lsp.utils').on_attach(client, bufnr)
            local lines = vim.api.nvim_buf_get_lines(bufnr, 0, 1, false)
            if lines ~= nil and #lines > 0 then
              if lines[1] == '//go:build js' then
                print("Setting GOARCH to wasm")
                client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                  gopls = {
                    env = {
                      GOOS = 'js',
                      GOARCH = 'wasm',
                    },
                  },
                })
                client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
              end
            end
          end
        },
        jsonls = {
          settings = {
            json = {
              schemas = {
                {
                  fileMatch = { '*.fhir.json' },
                  url = 'https://hl7.org/fhir/r4/fhir.schema.json',
                },
              },
              validate = {
                enable = true,
              },
            },
          },
        },
        ts_ls = {},
        eslint = {},
        vimls = {},
        bashls = {
          filetypes = { 'sh', 'zsh' },
        },
        -- rust_analyzer = {
        --   cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' }
        -- },
        pyright = {},
        lua_ls = {
          settings = {
            Lua = {
              format = {
                enable = true,
                defaultConfig = {
                  indent_size = '2',
                  indent_style = 'space',
                },
              },
            },
          },
          on_init = init_luals,
        },
      },
    },
    config = function(_, opts)
      local lsp_utils = require 'nikklassen.lsp.utils'
      local nvim_lsp = require 'lspconfig'

      vim.diagnostic.config(opts.diagnostics)
      vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(vim.lsp.diagnostic.on_publish_diagnostics, {})

      if opts.debug then
        vim.lsp.set_log_level('debug')
      end

      local default_config = lsp_utils.default_config()

      for server, server_config in pairs(opts.servers) do
        server_config = vim.tbl_deep_extend('force', default_config, server_config)
        nvim_lsp[server].setup(server_config)
      end
    end,
  },
}
