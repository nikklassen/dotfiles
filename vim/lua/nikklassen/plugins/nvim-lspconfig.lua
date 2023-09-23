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
                },
                jsonls = {
                    init_options = {
                        provideFormatter = true,
                    },
                    settings = {
                        json = {
                            schemas = {
                                {
                                    fileMatch = { '*\\.fhir\\.json' },
                                    url = 'https://hl7.org/fhir/r4/fhir.schema.json',
                                },
                            },
                            validate = {
                                enable = true,
                            },
                        },
                    },
                },
                tsserver = {},
                eslint = {},
                vimls = {},
                bashls = {},
                rust_analyzer = {
                    cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' }
                },
                pyright = {},
                lua_ls = {
                    on_init = function(client)
                        local path = client.workspace_folders[1].name
                        if not vim.uv.fs_stat(path .. '/.luarc.json') and not vim.uv.fs_stat(path .. '/.luarc.jsonc') then
                            client.config.settings = vim.tbl_deep_extend('force', client.config.settings, {
                                Lua = {
                                    runtime = {
                                        version = 'LuaJIT'
                                    },
                                    format = {
                                        enable = true,
                                        defaultConfig = {
                                            indent_size = '4',
                                            indent_style = 'space',
                                        },
                                    },
                                    -- Make the server aware of Neovim runtime files
                                    workspace = {
                                        checkThirdParty = false,
                                        library = vim.api.nvim_get_runtime_file("", true)
                                    },
                                    completion = {
                                        callSnippet = "Replace",
                                    },
                                }
                            })

                            client.notify("workspace/didChangeConfiguration", { settings = client.config.settings })
                        end
                        return true
                    end,

                },
            },
        },
        config = function(_, opts)
            local lsp_utils = require 'nikklassen.lsp.utils'
            local nvim_lsp = require 'lspconfig'

            vim.diagnostic.config(opts.diagnostics)

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
    {
        "nvimdev/lspsaga.nvim",
        dependencies = {
            "nvim-tree/nvim-web-devicons",
            "nvim-treesitter/nvim-treesitter",
        },
        event = "LspAttach",
        cmd = "Lspsaga",
        config = function()
            require("lspsaga").setup({
                -- use enter to open file with finder
                finder_action_keys = {
                    open = "<CR>",
                },
                -- use enter to open file with definition preview
                definition_action_keys = {
                    edit = "<CR>",
                },
                code_action = {
                    keys = {
                        quit = { "q", "<esc>" },
                    },
                },
                lightbulb = {
                    virtual_text = false,
                },
            })
        end,
    },
}
