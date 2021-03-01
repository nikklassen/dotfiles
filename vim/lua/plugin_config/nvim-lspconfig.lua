local lsp_utils = require('lsp/utils')

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
    local servers = {'jsonls', 'vimls', 'gopls'}
    for _, lsp in ipairs(servers) do
        nvim_lsp[lsp].setup {
            on_attach = lsp_utils.on_attach,
            capabilities = capabilities,
            init_options = {
                usePlaceholders = true
            }
        }
    end

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
