local M = {
  DEBUG = vim.env.NK_LSP_DEBUG
}

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

---@param client_name string
---@param bufnr number
function M.organize_imports_and_format(client_name, bufnr)
  if client_name == 'ts_ls' then
    local command = {
      command = '_typescript.organizeImports',
      arguments = { vim.fn.expand('%:p') },
    }
    vim.lsp.get_clients({
      name = 'ts_ls'
    })[1]:exec_cmd(command, { bufnr = bufnr })
  else
    local params = vim.lsp.util.make_range_params(nil, 'utf-8')
    params.context = { only = { "source.organizeImports" } }
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(bufnr, "textDocument/codeAction", params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
          vim.lsp.util.apply_workspace_edit(r.edit, enc)
        end
      end
    end
  end
  vim.lsp.buf.format()
end

local function current_line_has_float()
  local cur_window_id = vim.api.nvim_get_current_win()
  local cur_winline = vim.fn.screenrow()
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local config = vim.api.nvim_win_get_config(win)
    if config.relative == '' or cur_window_id ~= config.win then
      goto continue
    end
    if config.relative == 'win' and config.row == cur_winline then
      return true
    end
    ::continue::
  end
  return false
end

local function show_diagnostics()
  if current_line_has_float() then
    return
  end
  local ok, show = pcall(require, 'lspsaga.diagnostic.show')
  if not ok then
    vim.diagnostic.open_float({
      focusable = false
    })
  else
    show:show_diagnostics({ line = true, args = { '++unfocus' } })
  end
end

---@param client vim.lsp.Client
---@param bufnr number
---@param autoformat boolean
---@param lsp_augroup number
local function setup_document_formatting(client, bufnr, autoformat, lsp_augroup)
  if not client.server_capabilities.documentFormattingProvider or not autoformat then
    return
  end

  local code_actions = vim.tbl_get(client, 'server_capabilities', 'codeActionProvider', 'codeActionKinds') or {}
  local supports_organize_imports = vim.tbl_contains(code_actions, 'source.organizeImports') or client.name == 'ts_ls'
  if supports_organize_imports then
    vim.api.nvim_buf_create_user_command(bufnr, 'OrganizeImports', function()
      M.organize_imports_and_format(client.name, bufnr)
    end, {})
  end

  vim.api.nvim_create_autocmd('BufWritePre', {
    group = lsp_augroup,
    buffer = bufnr,
    callback = function()
      if supports_organize_imports then
        M.organize_imports_and_format(client.name, bufnr)
      else
        vim.lsp.buf.format { bufnr = bufnr }
      end
    end
  })
end

local function setup_range_formatting(client, bufnr, autoformat, lsp_augroup)
  if not client.server_capabilities.documentRangeFormattingProvider or client.server_capabilities.documentFormattingProvider or not autoformat then
    return
  end

  -- Currently just for jsonls
  vim.api.nvim_create_autocmd('BufWritePre', {
    group = lsp_augroup,
    buffer = bufnr,
    callback = function() range_format_sync({}, { 0, 0 }, { vim.fn.line("$"), 0 }) end
  })
end

---Setups up formatting exprs and autocommands
---@param client vim.lsp.Client
---@param bufnr number
---@param lsp_augroup number
local function setup_formatting(client, bufnr, lsp_augroup)
  local autoformat = vim.tbl_get(client.config, 'settings', 'autoformat')
  if type(autoformat) == 'table' then
    autoformat = autoformat[vim.bo[bufnr].filetype]
  end
  if autoformat == nil then
    autoformat = true
  end
  setup_document_formatting(client, bufnr, autoformat, lsp_augroup)
  setup_range_formatting(client, bufnr, autoformat, lsp_augroup)
end

local function nvim_v0_11_polyfill(client, opts)
  if client.supports_method('textDocument/signatureHelp') then
    vim.keymap.set('i', '<C-s>', vim.lsp.buf.signature_help, opts)
  end
  if client.supports_method('textDocument/codeAction') then
    vim.keymap.set({ 'n', 'v' }, 'gra', vim.lsp.buf.code_action, opts)
  end
  vim.keymap.set('n', 'grn', vim.lsp.buf.rename, opts)
  vim.keymap.set('n', 'grr', vim.lsp.buf.references, opts)
  vim.keymap.set('n', 'gri', vim.lsp.buf.implementation, opts)
  vim.keymap.set('n', 'gO', vim.lsp.buf.document_symbol, opts)
end

---Configures LSP client for this buffer
---@param client vim.lsp.Client
---@param bufnr number
function M.on_attach(client, bufnr)
  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'K', function()
    if require 'dap'.session() ~= nil then
      require('dap.ui.widgets').hover()
    else
      local ok, hover = pcall(require, 'lspsaga.hover')
      if not ok then
        vim.lsp.buf.hover()
      else
        hover:render_hover_doc({})
      end
    end
  end, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

  local next_diagnostic = function()
    local goto_opts = goto_diagnostic_options()
    if goto_opts == nil then
      return
    end
    -- vim.diagnostic.goto_prev(goto_opts)
    local d = vim.diagnostic.get_prev(goto_opts)
    if d == nil then
      return
    end
    vim.api.nvim_win_set_cursor(0, { d.lnum + 1, d.col })
    show_diagnostics()
  end
  vim.keymap.set('n', '<Up>', next_diagnostic, opts)
  vim.keymap.set('n', ']d', next_diagnostic, opts)
  local prev_diagnostic = function()
    local goto_opts = goto_diagnostic_options()
    if goto_opts == nil then
      return
    end
    -- vim.diagnostic.goto_next(goto_opts)
    local d = vim.diagnostic.get_next(goto_opts)
    if d == nil then
      return
    end
    vim.api.nvim_win_set_cursor(0, { d.lnum + 1, d.col })
    show_diagnostics()
  end
  vim.keymap.set('n', '<Down>', prev_diagnostic, opts)
  vim.keymap.set('n', '[d', prev_diagnostic, opts)

  local lsp_augroup = vim.api.nvim_create_augroup('lsp_buf_' .. bufnr .. '_' .. client.name, {})
  vim.api.nvim_create_autocmd('CursorHold', {
    group = lsp_augroup,
    buffer = bufnr,
    callback = show_diagnostics,
  })

  setup_formatting(client, bufnr, lsp_augroup)

  if client.supports_method('textDocument/signatureHelp') then
    local lsp_signature, err = pcall(require, 'lsp_signature')
    if err == nil then
      lsp_signature.on_attach({}, bufnr)
    end
  end

  -- TODO: delete when nvim 0.11 is stable
  nvim_v0_11_polyfill(client, opts)

  -- Set autocommands conditional on server_capabilities
  if client.supports_method('textDocument/documentHighlight', { bufnr = bufnr }) then
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { link = 'Underlined', default = true })
    vim.api.nvim_set_hl(0, 'LspReferenceText', { link = 'Normal', default = true })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { link = 'Underlined', default = true })
    local lsp_highlight_augroup = vim.api.nvim_create_augroup('lsp_highlight_buf_' .. bufnr, {})
    vim.api.nvim_create_autocmd('CursorHold', {
      group = lsp_highlight_augroup,
      buffer = bufnr,
      callback = vim.lsp.buf.document_highlight,
    })
    vim.api.nvim_create_autocmd('CursorMoved', {
      group = lsp_highlight_augroup,
      buffer = bufnr,
      callback = vim.lsp.buf.clear_references,
    })
  end
end

function M.default_config()
  return {
    on_attach = M.on_attach,
    capabilities = require('blink.cmp').get_lsp_capabilities(),
  }
end

return M
