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
    if not result or next(result) == nil then return end
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
    local nvim_lsp = require'lspconfig'

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            virtual_text = true,
            signs = true,
            -- update_in_insert = true,
            update_in_insert = false,
        }
    )

    -- vim.lsp.set_log_level('debug')

    local default_config = lsp_utils.default_config()

    nvim_lsp.gopls.setup(vim.tbl_deep_extend('force', default_config, {
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
            cmd = {'rustup', 'run', 'nightly', 'rust-analyzer'}
        }))
    end

    if vim.fn.executable('pyright') == 1 then
        nvim_lsp.pyright.setup(default_config)
    end

    local sumneko_root_path = vim.env.HOME .. '/lua-language-server'
    local sumneko_binary = sumneko_root_path..'/bin/Linux/lua-language-server'
    nvim_lsp.sumneko_lua.setup(vim.tbl_deep_extend('force', default_config, {
        cmd = {sumneko_binary, '-E', sumneko_root_path .. '/main.lua'},
        settings = {
            Lua = {
                runtime = {
                    -- Tell the language server which version of Lua you're using (most likely LuaJIT in the case of Neovim)
                    version = 'LuaJIT',
                    -- Setup your lua path
                    path = vim.split(package.path, ';'),
                },
                diagnostics = {
                    -- Get the language server to recognize the `vim` global
                    globals = {'vim', 'use_rocks'},
                },
                workspace = {
                    -- Make the server aware of Neovim runtime files
                    library = {
                        [vim.fn.expand('$VIMRUNTIME/lua')] = true,
                        [vim.fn.expand('$VIMRUNTIME/lua/vim/lsp')] = true,
                    },
                },
            },
        },
    }))
end

return M
