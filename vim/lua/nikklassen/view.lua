local function should_persist_view(fname)
  return fname ~= '' and vim.fn.filereadable(fname) == 1
end

vim.opt.viewoptions:remove('curdir')

local function save_view_settings(ev)
  if should_persist_view(ev.file) then
    vim.cmd('mkview!')
  end
end

local function load_view_settings(ev)
  if should_persist_view(ev.file) then
    vim.cmd('silent! loadview')
  end
end

local remember_folds_ag = vim.api.nvim_create_augroup('remember_folds', {
  clear = true
})
vim.api.nvim_create_autocmd('BufWinLeave', {
  pattern = '*',
  callback = save_view_settings,
  group = remember_folds_ag,
})
vim.api.nvim_create_autocmd('BufWinEnter', {
  pattern = '*',
  callback = load_view_settings,
  group = remember_folds_ag,
})

-- Jump to the last position on load
vim.api.nvim_create_autocmd('BufReadPost', {
  pattern = '*',
  callback = function()
    local last_position = vim.fn.line('\'"')
    if last_position > 1 and last_position <= vim.fn.line('$') then
      vim.cmd('normal! g`"')
    end
  end,
})

vim.wo.foldminlines = 4
vim.wo.foldnestmax = 3
vim.o.foldopen = 'block,hor,mark,percent,quickfix,search,tag,undo,jump'

local function adjust_qf_height(minheight, maxheight)
  local height = math.max(math.min(vim.fn.line('$'), maxheight), minheight)
  vim.api.nvim_win_set_height(0, height)
end

-- Keep the quickfix window small when there aren't many lines
vim.api.nvim_create_autocmd('FileType', {
  pattern = 'qf',
  callback = function() adjust_qf_height(3, 10) end,
})

local function zoom()
  local height = vim.api.nvim_win_get_height(0)
  if height >= vim.o.lines - 3 then
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-W>=', true, false, true), 'm', true)
  else
    vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes('<C-W>_<C-W>|', true, false, true), 'm', true)
  end
end

vim.keymap.set('n', '<C-W>z', zoom)
