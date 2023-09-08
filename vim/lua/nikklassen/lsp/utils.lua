local utils = require 'nikklassen.utils'
local dap = require 'dap'

local M = {}

function M.capabilities()
    local capabilities
    if utils.has_plugin('cmp_nvim_lsp') then
        capabilities = require 'cmp_nvim_lsp'.default_capabilities()
    elseif utils.has_plugin('coq') then
        capabilities = require 'coq'.lsp_ensure_capabilities(capabilities)
    else
        capabilities = vim.lsp.protocol.make_client_capabilities()
    end
    if utils.has_plugin('lsp-status') then
        capabilities = vim.tbl_extend('keep', capabilities, require 'lsp-status'.capabilities)
    end
    return capabilities
end

local function range_format_sync(options, start_pos, end_pos)
    vim.validate { options = { options, 't', true } }
    local sts = vim.bo.softtabstop;
    options = vim.tbl_extend('keep', options or {}, {
        tabSize = (sts > 0 and sts) or (sts < 0 and vim.bo.shiftwidth) or vim.bo.tabstop,
        insertSpaces = vim.bo.expandtab,
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

local function goto_diagnostic_options()
    local severities = {
        vim.diagnostic.severity.ERROR,
        vim.diagnostic.severity.WARN,
        vim.diagnostic.severity.INFO,
        vim.diagnostic.severity.HINT,
    }
    for _, severity in ipairs(severities) do
        local diagnostics = vim.diagnostic.get(0, { severity = severity })
        if #diagnostics > 0 then
            return { severity = severity }
        end
    end
    return nil
end

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

function M.on_attach(client, bufnr)
    if utils.has_plugin('lsp-status') then
        require 'lsp-status'.on_attach(client, bufnr)
    end
    if utils.has_plugin('lsp_signature') then
        require 'lsp_signature'.on_attach({}, bufnr)
    end

    vim.bo[bufnr].omnifunc = 'v:lua.vim.lsp.omnifunc'

    local opts = { noremap = true, silent = true, buffer = bufnr }
    vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
    vim.keymap.set('n', 'K', function()
        if dap.session() ~= nil then
            require('dap.ui.widgets').hover()
        else
            vim.lsp.buf.hover()
        end
    end, opts)
    vim.keymap.set('n', '<F2>', vim.lsp.buf.rename, opts)
    -- Shift F12
    vim.keymap.set('n', '<S-F12>', vim.lsp.buf.references, opts)
    vim.keymap.set('n', '<F24>', vim.lsp.buf.references, opts)

    vim.keymap.set('n', '<Up>', function()
        local goto_opts = goto_diagnostic_options()
        if goto_opts == nil then
            return
        end
        vim.diagnostic.goto_prev(goto_opts)
    end, opts)
    vim.keymap.set('n', '<Down>', function()
        local goto_opts = goto_diagnostic_options()
        if goto_opts == nil then
            return
        end
        vim.diagnostic.goto_next(goto_opts)
    end, opts)
    vim.api.nvim_create_autocmd('CursorHold', {
        group = lsp_augroup,
        buffer = bufnr,
        callback = function()
            vim.diagnostic.open_float({
                focusable = false
            })
        end,
    })

    if client.server_capabilities.declarationProvider then
        vim.keymap.set('n', '<c-]>', vim.lsp.buf.declaration, opts)
    end
    local autoformat = vim.tbl_get(client.config, 'settings', 'autoformat')
    if type(autoformat) == 'table' then
        autoformat = autoformat[vim.bo[bufnr].filetype]
    end
    if autoformat == nil then
        autoformat = true
    end
    if client.server_capabilities.documentFormattingProvider then
        vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr'

        if autoformat then
            vim.api.nvim_create_autocmd('BufWritePre', {
                group = lsp_augroup,
                buffer = bufnr,
                callback = function()
                    vim.lsp.buf.format {
                        timeout_ms = 1000
                    }
                    if client.name == 'gopls' then
                        vim.lsp.buf.code_action({ context = { only = { 'source.organizeImports' } }, apply = true })
                        -- goimports(1000)
                    end
                end
            })
        end
    end
    if client.server_capabilities.documentRangeFormattingProvider then
        vim.bo[bufnr].formatexpr = 'v:lua.vim.lsp.formatexpr'

        -- Currently just for jsonls
        if not client.server_capabilities.documentFormattingProvider then
            if autoformat then
                vim.api.nvim_create_autocmd('BufWritePre', {
                    group = lsp_augroup,
                    buffer = bufnr,
                    callback = function() range_format_sync({}, { 0, 0 }, { vim.fn.line("$"), 0 }) end
                })
            end
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
        vim.api.nvim_create_autocmd('CursorHold', {
            group = lsp_augroup,
            buffer = bufnr,
            callback = vim.lsp.buf.document_highlight,
        })
        vim.api.nvim_create_autocmd('CursorMoved', {
            group = lsp_augroup,
            buffer = bufnr,
            callback = vim.lsp.buf.clear_references,
        })
    end
end

function M.default_config()
    return {
        on_attach = M.on_attach,
        capabilities = M.capabilities(),
        init_options = {
            usePlaceholders = true
        },
    }
end

return M
