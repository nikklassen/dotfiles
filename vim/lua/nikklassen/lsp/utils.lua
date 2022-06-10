local utils = require'nikklassen.utils'

local M = {}

function M.snippet_capabilities()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    if utils.isModuleAvailable('cmp_nvim_lsp') then
        capabilities = require'cmp_nvim_lsp'.update_capabilities(capabilities)
    end
    if utils.isModuleAvailable('coq') then
        capabilities = require'coq'.lsp_ensure_capabilities(capabilities)
    end
    return capabilities
end

local function range_format_sync(options, start_pos, end_pos)
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
    vim.lsp.util.apply_text_edits(result, 0, 'utf-8')
end

local function preview_location_callback(err, result, _)
  if err ~= nil then
      print('failed to get location:', err)
      return nil
  end
  if result == nil or vim.tbl_isempty(result) then
    return nil
  end
  if vim.tbl_islist(result) then
    vim.lsp.util.preview_location(result[1])
  else
    vim.lsp.util.preview_location(result)
  end
end

function M.peek_definition()
  local params = vim.lsp.util.make_position_params()
  return vim.lsp.buf_request(0, 'textDocument/typeDefinition', params, preview_location_callback)
end

function M.on_attach(client, bufnr)
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    -- Shift F12
    vim.keymap.set('n', '<S-F12>', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<F24>', vim.lsp.buf.references, opts)

    vim.keymap.set('n', '<Up>', vim.diagnostic.goto_prev, opts)
    vim.keymap.set('n', '<Down>', vim.diagnostic.goto_next, opts)

    if client.server_capabilities.declarationProvider then
        vim.keymap.set('n', '<c-]>', vim.lsp.buf.declaration, opts)
    end
    if client.server_capabilities.documentFormattingProvider then
        if vim.lsp.formatexpr then -- Neovim v0.6.0+ only.
            buf_set_option('formatexpr', 'v:lua.vim.lsp.formatexpr')
        else
            vim.keymap.set('n', '<leader>=', vim.lsp.buf.formatting, opts)
        end
        vim.api.nvim_create_autocmd('BufWritePre', {
            buffer = bufnr,
            callback = function()
                vim.lsp.buf.format {
                    timeout_ms = 1000
                }
            end
        })
    end
    if client.server_capabilities.documentRangeFormattingProvider then
        if vim.lsp.formatexpr then -- Neovim v0.6.0+ only.
            buf_set_option('formatexpr', 'v:lua.vim.lsp.formatexpr')
        else
            vim.keymap.set('n', '==', function()
                local linenr = vim.fn.line(".")
                vim.lsp.buf.range_formatting(nil, {linenr, 0}, {linenr + 1, 0})
            end, opts)
            vim.keymap.set('v', '=', vim.lsp.buf.range_formatting, opts)
        end
        -- Currently just for jsonls
        if not client.server_capabilities.documentFormattingProvider then
            vim.api.nvim_create_autocmd('BufWritePre', {
                buffer = bufnr,
                callback = function() range_format_sync({},{0,0},{vim.fn.line("$"),0}) end
            })
        end
    end

    if client.server_capabilities.signatureHelpProvider then
        vim.keymap.set('i', '<M-k>', vim.lsp.buf.signature_help, opts)
    end

    if client.server_capabilities.codeActionProvider then
        vim.keymap.set('n', '<C-.>', vim.lsp.buf.code_action, opts)
    end

    -- Set autocommands conditional on server_capabilities
    if client.server_capabilities.documentHighlightProvider then
        vim.api.nvim_set_hl(0, 'LspReferenceRead', { link = 'Underlined', default = true })
        vim.api.nvim_set_hl(0, 'LspReferenceText', { link = 'Normal', default = true })
        vim.api.nvim_set_hl(0, 'LspReferenceWrite', { link = 'Underlined', default = true })
        local lsp_document_highlight_ag = vim.api.nvim_create_augroup('lsp_document_highlight', {
            clear = true,
        })
        vim.api.nvim_create_autocmd('CursorHold', {
            group = lsp_document_highlight_ag,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
            group = lsp_document_highlight_ag,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
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
