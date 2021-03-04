local M = {}

function M.snippet_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = true
    return capabilities
end

function M.on_attach(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    -- Shift F12
    buf_set_keymap('n', '<F24>', '<cmd>lua vim.lsp.buf.references()<CR>', opts)

    buf_set_keymap('n', '<Up>', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', '<Down>', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)

    if client.resolved_capabilities.declaration then
        buf_set_keymap('n', '<c-]>', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    end
    if client.resolved_capabilities.document_formatting then
        buf_set_keymap('n', '<leader>=', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
        vim.api.nvim_exec([[
        autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)
        ]], false)
    end
    if client.resolved_capabilities.document_range_formatting then
        buf_set_keymap('n', '==', [[<cmd>lua local linenr = vim.fn.line('.'); vim.lsp.buf.range_formatting(nil, {linenr, 0}, {linenr + 1, 0})<CR>]], opts)
        buf_set_keymap('v', '=', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
    end

    if client.resolved_capabilities.signature_help then
        buf_set_keymap('i', '<M-K>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi LspReferenceRead cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceText cterm=bold ctermbg=red guibg=LightYellow
        hi LspReferenceWrite cterm=bold ctermbg=red guibg=LightYellow
        augroup lsp_document_highlight
        autocmd! * <buffer>
        autocmd CursorHold <buffer> lua vim.lsp.buf.document_highlight()
        autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
end

return M
