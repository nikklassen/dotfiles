local M = {}

function M.snippet_capabilities()
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)
  return capabilities
end

function M.range_format_sync(options, start_pos, end_pos)
    vim.validate { options = {options, 't', true} }
    local sts = vim.bo.softtabstop;
    options = vim.tbl_extend('keep', options or {}, {
        tabSize = (sts > 0 and sts) or (sts < 0 and vim.bo.shiftwidth) or vim.bo.tabstop;
        insertSpaces = vim.bo.expandtab;
    })
    local params = vim.lsp.util.make_given_range_params(start_pos, end_pos)
    params.options = options
    local result = vim.lsp.buf_request_sync(0, 'textDocument/rangeFormatting', params, 1000)
    if not result or vim.tbl_isempty(result) then return end
    local _, formatting_result = next(result)
    result = formatting_result.result
    if not result then return end
    vim.lsp.util.apply_text_edits(result)
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
        buf_set_keymap('n', '==', '<cmd>lua local linenr = vim.fn.line("."); vim.lsp.buf.range_formatting(nil, {linenr, 0}, {linenr + 1, 0})<CR>', opts)
        buf_set_keymap('v', '=', '<cmd>lua vim.lsp.buf.range_formatting()<CR>', opts)
        -- Currently just for jsonls
        if not client.resolved_capabilities.document_formatting then
            vim.api.nvim_exec([[
            autocmd BufWritePre <buffer> lua require'nikklassen.lsp.utils'.range_format_sync({},{0,0},{vim.fn.line("$"),0})
            ]], false)
        end
    end

    if client.resolved_capabilities.signature_help then
        buf_set_keymap('i', '<M-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    end

    if client.resolved_capabilities.code_action then
        buf_set_keymap('n', '<C-.>', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.resolved_capabilities.document_highlight then
        vim.api.nvim_exec([[
        hi link LspReferenceRead Underlined
        hi link LspReferenceText Normal
        hi link LspReferenceWrite Underlined

        augroup lsp_document_highlight
        au! * <buffer>
          au CursorHold <buffer> lua vim.lsp.buf.document_highlight()
          au CursorMoved <buffer> lua vim.lsp.buf.clear_references()
        augroup END
        ]], false)
    end
end

function M.default_config()
    return {
        on_attach = M.on_attach,
        capabilities = M.snippet_capabilities(),
        init_options = {
            usePlaceholders = true
        },
    }
end

return M
