---Scratch line comments.
---
---Lets you attach free-form notes to lines across files, then dump them all as
---`<path>:<line>:<text>` for pasting somewhere else (a doc, a chat, a CL
---comment). Comments live in memory for the session only.
local M = {}

local NS = vim.api.nvim_create_namespace('nikklassen.comments')
local HL = 'DiagnosticVirtualTextInfo'
local SIGN_TEXT = '●'

---@class nikklassen.Comment
---@field path string Absolute path of the commented file.
---@field text string The comment body.
---@field line integer 1-indexed line. Authoritative only when there is no live extmark.
---@field bufnr integer? Buffer holding the extmark, if the file is loaded.
---@field extmark_id integer?

---@type nikklassen.Comment[]
local comments = {}

---@param bufnr integer
---@return string? path Absolute path of the buffer, nil for unnamed buffers.
local function buf_path(bufnr)
  local name = vim.api.nvim_buf_get_name(bufnr)
  if name == '' then
    return nil
  end
  return vim.fn.fnamemodify(name, ':p')
end

---@param c nikklassen.Comment
---@return boolean
local function is_attached(c)
  return c.extmark_id ~= nil and c.bufnr ~= nil and vim.api.nvim_buf_is_loaded(c.bufnr)
end

---Reads the comment's current line back out of its extmark, so edits above it
---don't stale the recorded position.
---@param c nikklassen.Comment
local function sync_line(c)
  if not is_attached(c) then
    return
  end
  local pos = vim.api.nvim_buf_get_extmark_by_id(c.bufnr, NS, c.extmark_id, {})
  if #pos > 0 then
    c.line = pos[1] + 1
  end
end

---Creates or updates the extmark for a comment in its (loaded) buffer.
---@param c nikklassen.Comment
local function render(c)
  if c.bufnr == nil or not vim.api.nvim_buf_is_loaded(c.bufnr) then
    return
  end
  sync_line(c)
  local row = math.min(c.line, vim.api.nvim_buf_line_count(c.bufnr)) - 1
  local line = vim.api.nvim_buf_get_lines(c.bufnr, row, row + 1, false)[1] or ''
  local indent = line:match('^%s*')
  c.extmark_id = vim.api.nvim_buf_set_extmark(c.bufnr, NS, row, 0, {
    id = c.extmark_id,
    virt_lines = { { { indent .. SIGN_TEXT .. ' ' .. c.text, HL } } },
    sign_text = SIGN_TEXT,
    sign_hl_group = HL,
  })
end

---@param c nikklassen.Comment
local function unrender(c)
  if is_attached(c) then
    vim.api.nvim_buf_del_extmark(c.bufnr, NS, c.extmark_id)
  end
  c.extmark_id = nil
end

---@param bufnr integer
---@param line integer 1-indexed
---@return nikklassen.Comment?
---@return integer? index
local function find(bufnr, line)
  local path = buf_path(bufnr)
  for i, c in ipairs(comments) do
    sync_line(c)
    if c.path == path and c.line == line then
      return c, i
    end
  end
  return nil, nil
end

---Path as it should appear in the copied output, relative to cwd.
---@param path string
---@return string
local function display_path(path)
  return vim.fn.fnamemodify(path, ':~:.')
end

M.display_path = display_path

---All comments, sorted by file then line, with their positions refreshed.
---@return nikklassen.Comment[]
local function sorted()
  local result = vim.list_slice(comments)
  for _, c in ipairs(result) do
    sync_line(c)
  end
  table.sort(result, function(a, b)
    if a.path ~= b.path then
      return a.path < b.path
    end
    return a.line < b.line
  end)
  return result
end

---Prompts for a comment on the current line, editing the existing one if there
---already is one.
function M.add()
  local bufnr = vim.api.nvim_get_current_buf()
  local path = buf_path(bufnr)
  if path == nil then
    vim.notify('Cannot comment on an unnamed buffer', vim.log.levels.ERROR)
    return
  end
  local line = vim.fn.line('.')
  local existing = find(bufnr, line)

  vim.ui.input({ prompt = 'Comment: ', default = existing and existing.text or nil }, function(input)
    if input == nil or input == '' then
      return
    end
    if existing then
      existing.text = input
      render(existing)
      return
    end
    local c = { path = path, text = input, line = line, bufnr = bufnr }
    table.insert(comments, c)
    render(c)
  end)
end

---Removes the comment on the current line.
function M.delete()
  local c, i = find(vim.api.nvim_get_current_buf(), vim.fn.line('.'))
  if c == nil then
    vim.notify('No comment on this line', vim.log.levels.WARN)
    return
  end
  unrender(c)
  table.remove(comments, i)
end

---Removes every comment.
function M.clear()
  for _, c in ipairs(comments) do
    unrender(c)
  end
  comments = {}
end

---@param displayer fun(string): string
---@return string[] lines formatted as `<file><path>:<line>:<text>`
local function comments_with_line(displayer)
  return vim.tbl_map(function(c)
    return ('<file>%s:%d:%s'):format(displayer(c.path), c.line, c.text)
  end, sorted())
end

---Copies all comments to the system clipboard.
---@param clear boolean Whether to drop the comments afterwards.
function M.copy(clear)
  local lines = comments_with_line(M.display_path)
  if #lines == 0 then
    vim.notify('No comments to copy', vim.log.levels.WARN)
    return
  end
  vim.fn.setreg('+', lines, 'l')
  if clear then
    M.clear()
  end
  vim.notify(('Copied %d comment(s)'):format(#lines))
end

---Puts all comments in the quickfix list.
function M.list()
  local items = vim.tbl_map(function(c)
    return { filename = c.path, lnum = c.line, col = 1, text = c.text }
  end, sorted())
  if #items == 0 then
    vim.notify('No comments', vim.log.levels.WARN)
    return
  end
  vim.fn.setqflist({}, ' ', { title = 'Comments', items = items })
  vim.cmd.copen()
end

---Re-attaches comments for a file that was (re)loaded into a buffer.
---@param bufnr integer
function M.on_buf_read(bufnr)
  local path = buf_path(bufnr)
  if path == nil then
    return
  end
  -- A reload (`:edit`) keeps the old extmarks around but fires BufUnload first,
  -- so drop everything we own in the buffer and rebuild it from scratch.
  for _, c in ipairs(comments) do
    if c.path == path then
      sync_line(c)
    end
  end
  vim.api.nvim_buf_clear_namespace(bufnr, NS, 0, -1)
  for _, c in ipairs(comments) do
    if c.path == path then
      c.bufnr = bufnr
      c.extmark_id = nil
      render(c)
    end
  end
end

---Freezes comment positions before their buffer goes away, so they survive a
---`:bdelete` and come back on the next read.
---@param bufnr integer
function M.on_buf_unload(bufnr)
  for _, c in ipairs(comments) do
    if c.bufnr == bufnr then
      sync_line(c)
      c.bufnr = nil
      c.extmark_id = nil
    end
  end
end

return M
