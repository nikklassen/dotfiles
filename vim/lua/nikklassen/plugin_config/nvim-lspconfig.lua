local lsp_utils = require'nikklassen.lsp.utils'

local M = {}

function M.go_organize_imports_sync(timeout_ms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, 't', true } }
    local params = vim.lsp.util.make_range_params()
    params.context = context

    local result = vim.lsp.buf_request_sync(0, 'textDocument/codeAction', params, timeout_ms)
    if not result then return end
    result = result[1].result
    if not result then return end
    local edit = result[1].edit
    vim.lsp.util.apply_workspace_edit(edit)
end

local function on_attach_gopls(client, bufnr)
    vim.cmd([[au BufWritePre <buffer> lua require'nikklassen.plugin_config.nvim-lspconfig'.go_organize_imports_sync(1000)]])
    return lsp_utils.on_attach(client, bufnr)
end

function M.configure()
    local nvim_lsp = require'lspconfig'

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            virtual_text = true,
            signs = true,
            update_in_insert = true,
        }
    )

    local capabilities = lsp_utils.snippet_capabilities()

    nvim_lsp.gopls.setup {
        on_attach = on_attach_gopls,
        capabilities = capabilities,
        init_options = {
            usePlaceholders = true
        }
    }

    nvim_lsp.jsonls.setup{
        on_attach = lsp_utils.on_attach,
        capabilities = capabilities,
        init_options = {
            provideFormatter = true,
        },
    }

    nvim_lsp.tsserver.setup {
        on_attach = lsp_utils.on_attach,
        capabilities = capabilities,
        init_options = {
            usePlaceholders = true
        }
    }


    nvim_lsp.vimls.setup {
        on_attach = lsp_utils.on_attach,
        capabilities = capabilities,
        init_options = {
            usePlaceholders = true
        }
    }

    local sumneko_root_path = vim.env.HOME .. '/lua-language-server'
    local sumneko_binary = sumneko_root_path.."/bin/Linux/lua-language-server"
    nvim_lsp.sumneko_lua.setup {
        cmd = {sumneko_binary, "-E", sumneko_root_path .. "/main.lua"},
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
                    globals = {'vim'},
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
        on_attach = lsp_utils.on_attach,
    }
end

return M
