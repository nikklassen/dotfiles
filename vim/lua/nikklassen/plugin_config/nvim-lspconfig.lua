local lsp_utils = require'nikklassen.lsp.utils'

local M = {}

local function goimports(timeout_ms)
    local context = { only = { "source.organizeImports" } }
    vim.validate { context = { context, "t", true } }

    local params = vim.lsp.util.make_range_params()
    params.context = context

    -- See the implementation of the textDocument/codeAction callback
    -- (lua/vim/lsp/handler.lua) for how to do this properly.
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result or result[1] == nil then return end
    if result[1] == nil then return end
    local actions = result[1].result
    if not actions then return end
    local action = actions[1]

    -- textDocument/codeAction can return either Command[] or CodeAction[]. If it
    -- is a CodeAction, it can have either an edit, a command or both. Edits
    -- should be executed first.
    if action.edit or type(action.command) == "table" then
      if action.edit then
        vim.lsp.util.apply_workspace_edit(action.edit, 'utf-8')
      end
      if type(action.command) == "table" then
        vim.lsp.buf.execute_command(action.command)
      end
    else
      vim.lsp.buf.execute_command(action)
    end
end

local function on_attach_gopls(client, bufnr)
    vim.api.nvim_create_autocmd('BufWritePre', {
        buffer = bufnr,
        callback = function()
            goimports(1000)
        end,
    })
    return lsp_utils.on_attach(client, bufnr)
end

function M.configure()
    local nvim_lsp = require 'lspconfig'

    vim.diagnostic.config({
        virtual_text = false,
        signs = true,
        update_in_insert = false,
        underline = true,
        severity_sort = true,
        float = {
            focusable = false,
            style = 'minimal',
            border = 'rounded',
            source = 'always',
            header = '',
            prefix = '',
        },
    })

    -- vim.lsp.set_log_level('debug')

    local default_config = lsp_utils.default_config()

    local autostart_gopls = true
    if vim.g.gopls_autostart_disable ~= nil then
        autostart_gopls = not vim.g.gopls_autostart_disable
    end
    nvim_lsp.gopls.setup(vim.tbl_deep_extend('force', default_config, {
        autostart = autostart_gopls,
        on_attach = on_attach_gopls,
        settings = {
            gopls = {
                analyses = {
                    unusedparams = true,
                },
                staticcheck = true,
            },
        },
    }))

    nvim_lsp.jsonls.setup(vim.tbl_deep_extend('force', default_config, {
        init_options = {
            provideFormatter = true,
        },
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
    }))

    nvim_lsp.tsserver.setup(vim.tbl_deep_extend('force', default_config, {
        on_attach = function(client, bufnr)
            client.server_capabilities.documentFormattingProvider = false
            lsp_utils.on_attach(client, bufnr)
        end,
    }))

    if vim.fn.executable('vscode-eslint-language-server') == 1 then
        nvim_lsp.eslint.setup(default_config)
    end


    if vim.fn.executable('vim-language-server') == 1 then
        nvim_lsp.vimls.setup(default_config)
    end

    if vim.fn.executable('bash-language-server') == 1 then
        nvim_lsp.bashls.setup(default_config)
    end

    if vim.fn.executable('rustup') == 1 then
        nvim_lsp.rust_analyzer.setup(vim.tbl_deep_extend('force', default_config, {
            cmd = { 'rustup', 'run', 'nightly', 'rust-analyzer' }
        }))
    end

    if vim.fn.executable('pyright') == 1 then
        nvim_lsp.pyright.setup(vim.tbl_deep_extend('force', default_config, {
            autostart = false,
        }))
    end

    if vim.fn.executable('lua-language-server') == 1 then
        nvim_lsp.lua_ls.setup(vim.tbl_deep_extend('force', default_config, {
            settings = {
                Lua = {
                    runtime = {
                        -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                        version = 'LuaJIT',
                        -- Setup your lua path
                        -- path = vim.split(package.path, ';'),
                    },
                    diagnostics = {
                        -- Get the language server to recognize the `vim` global
                        globals = { 'vim', 'use_rocks' },
                    },
                    workspace = {
                        -- Make the server aware of Neovim runtime files
                        library = vim.api.nvim_get_runtime_file('', true),
                    },
                    telemetry = {
                        enable = false,
                    }
                },
            },
        }))
    end
end

return M
