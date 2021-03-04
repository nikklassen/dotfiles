local lsp_utils = require('lsp/utils')

function _G.go_organize_imports_sync(timeout_ms)
    local context = { source = { organizeImports = true } }
    vim.validate { context = { context, 't', true } }
    local params = vim.lsp.util.make_range_params()
    params.context = context

    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, timeout_ms)
    if not result then return end
    result = result[1].result
    if not result then return end
    local edit = result[1].edit
    vim.lsp.util.apply_workspace_edit(edit)
end

local function on_attach_gopls(client, bufnr)
    vim.cmd([[au BufWritePre <buffer> lua go_organize_imports_sync(1000)]])
    return lsp_utils.on_attach(client, bufnr)
end

function RegisterNvimLSP()
    if vim.fn.has('nvim-0.5') ~= 1 then
        return
    end

    local nvim_lsp = require('lspconfig')

    vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
        vim.lsp.diagnostic.on_publish_diagnostics, {
            underline = true,
            virtual_text = true,
            signs = true,
            update_in_insert = true,
        }
    )

    local capabilities = lsp_utils.snippet_capabilities()

    -- Use a loop to conveniently both setup defined servers
    -- and map buffer local keybindings when the language server attaches
    local servers = {'jsonls', 'vimls'}
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = lsp_utils.on_attach,
            capabilities = capabilities,
            init_options = {
                usePlaceholders = true
            }
        }
    end

    nvim_lsp.gopls.setup {
        on_attach = on_attach_gopls,
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

RegisterNvimLSP()
