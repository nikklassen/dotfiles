local ms = vim.lsp.protocol.Methods

local M = {
  DEBUG = vim.env.NK_LSP_DEBUG
}

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

---@param client vim.lsp.Client
---@param bufnr number
function M.organize_imports_and_format(client, bufnr)
  if client.name == 'ts_ls' then
    local command = {
      command = '_typescript.organizeImports',
      arguments = { vim.fn.expand('%:p') },
    }
    client:exec_cmd(command, { bufnr = bufnr })
  else
    local params = vim.lsp.util.make_range_params(nil, client.offset_encoding) ---@type table
    params.context = { only = { 'source.organizeImports' } }
    -- buf_request_sync defaults to a 1000ms timeout. Depending on your
    -- machine and codebase, you may want longer. Add an additional
    -- argument after params if you find that you have to write the file
    -- twice for changes to be saved.
    -- E.g., vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, 3000)
    local result = vim.lsp.buf_request_sync(bufnr, 'textDocument/codeAction', params)
    for cid, res in pairs(result or {}) do
      for _, r in pairs(res.result or {}) do
        if r.edit then
          local encoding = 'utf-16'
          local client_for_edit = vim.lsp.get_client_by_id(cid)
          if client_for_edit then
            encoding = client_for_edit.offset_encoding
          end
          vim.lsp.util.apply_workspace_edit(r.edit, encoding)
        end
      end
    end
  end
  vim.lsp.buf.format {
    id = client.id,
    bufnr = bufnr,
  }
end

local function current_line_has_float()
  local cur_window_id = vim.api.nvim_get_current_win()
  local cur_winline = vim.fn.winline()
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

---@param d vim.Diagnostic?
local function jump_to_diagnostic(d)
  if d == nil then
    return
  end
  local opts = { diagnostic = d }
  if not current_line_has_float() then
    opts.float = { focusable = false }
  end
  vim.diagnostic.jump(opts)
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
      M.organize_imports_and_format(client, bufnr)
    end, {})
  end

  vim.api.nvim_create_autocmd('BufWritePre', {
    group = lsp_augroup,
    buffer = bufnr,
    callback = function()
      if supports_organize_imports then
        M.organize_imports_and_format(client, bufnr)
      else
        vim.lsp.buf.format { bufnr = bufnr }
      end
    end
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
end

---Configures LSP client for this buffer
---@param client vim.lsp.Client
---@param bufnr number
function M.on_attach(client, bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename:find('Claude Code') and filename:match('%(proposed%)$') then
    client:stop()
    return
  end

  local opts = { noremap = true, silent = true, buffer = bufnr }
  vim.keymap.set('n', 'K', function()
    if require 'dap'.session() ~= nil then
      require('dap.ui.widgets').hover()
    else
      vim.lsp.buf.hover()
    end
  end, opts)
  vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)

  local next_diagnostic = function()
    local goto_opts = goto_diagnostic_options()
    if goto_opts == nil then
      return
    end
    jump_to_diagnostic(vim.diagnostic.get_prev(goto_opts))
  end
  vim.keymap.set('n', '<Up>', next_diagnostic, opts)
  vim.keymap.set('n', ']d', next_diagnostic, opts)
  local prev_diagnostic = function()
    local goto_opts = goto_diagnostic_options()
    if goto_opts == nil then
      return
    end
    jump_to_diagnostic(vim.diagnostic.get_next(goto_opts))
  end
  vim.keymap.set('n', '<Down>', prev_diagnostic, opts)
  vim.keymap.set('n', '[d', prev_diagnostic, opts)

  local lsp_augroup = vim.api.nvim_create_augroup('lsp_buf_' .. bufnr .. '_' .. client.name, {})

  setup_formatting(client, bufnr, lsp_augroup)

  -- Set autocommands conditional on server_capabilities
  if client:supports_method(ms.textDocument_documentHighlight, bufnr) and vim.bo.ft ~= 'bash' then
    vim.api.nvim_set_hl(0, 'LspReferenceRead', { link = 'Underlined', default = true })
    vim.api.nvim_set_hl(0, 'LspReferenceText', { link = 'Normal', default = true })
    vim.api.nvim_set_hl(0, 'LspReferenceWrite', { link = 'Underlined', default = true })
    local lsp_highlight_augroup = vim.api.nvim_create_augroup('lsp_highlight_buf_' .. bufnr, {})
    vim.api.nvim_create_autocmd({ 'CursorHold', 'CursorHoldI' }, {
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


  local disabled_inlay_hint_file_types = vim.tbl_get(client.config, 'settings', 'inlay_hints', 'disabled_file_types') or
      {}
  local disable_inlay_hints = vim.tbl_contains(disabled_inlay_hint_file_types, vim.bo[bufnr].filetype)
  if not disable_inlay_hints and client:supports_method(ms.textDocument_inlayHint, bufnr) then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

  require('nikklassen.lsp.inline_completion').attach(client, bufnr)
end

return M
