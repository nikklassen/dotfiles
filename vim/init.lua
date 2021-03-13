vim.o.compatible = false

vim.g.python_host_prog = '/usr/bin/python'
vim.g.python3_host_prog = '/usr/bin/python3'

require'nikklassen.plugins'
require'nikklassen.keymappings'
require'nikklassen.utils'

-- Better command-line completion
vim.o.wildmode = 'list:longest,full'

vim.o.wildignore = '*.o,*.pyc,*.hi'

-- Completion settings
vim.o.completeopt = 'menuone,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'

-- Show partial commands in the last line of the screen
vim.o.showcmd = true

-- Search commands
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.smartindent = true

-- Stop certain movements from always going to the first character of a line.
-- While this behaviour deviates from that of Vi, it does what most users
-- coming from other editors would expect.
vim.o.startofline = false

-- Instead of failing a command because of unsaved changes, instead raise a
-- dialogue asking if you wish to save changed files.
vim.o.confirm = true

-- Set the command window height to 2 lines, to avoid many cases of having to
-- "press <Enter> to continue"
vim.o.cmdheight=2

-- Display line numbers on the left
vim.wo.relativenumber = true
vim.wo.number = true

-- Shorter timeout for escape keys
vim.o.tm=250

-- conceal in insert (i), normal (n) and visual (v) modes
vim.o.concealcursor = 'n'
-- hide concealed text completely unless replacement character is defined
vim.o.conceallevel=2

vim.o.path = '.,/usr/include,,'

vim.o.hidden = true

vim.o.list = true

vim.o.mouse = 'a'

--------------------------------------------------------------
-- Indentation options
--------------------------------------------------------------
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2

vim.o.expandtab = true
vim.o.shiftround = true
vim.o.joinspaces = false

--------------------------------------------------------------
-- Custom commands
--------------------------------------------------------------

-- read the output of a shell command into a new scratch buffer
vim.cmd('command! -nargs=* -complete=shellcmd R new | setlocal buftype=nofile bufhidden=hide noswapfile | r !<args>')

--------------------------------------------------------------
-- View Settings
--------------------------------------------------------------

local function should_persist_view()
    local dir = vim.fn.expand('%:p')
    return (
      vim.fn.expand('%:t') ~= '' and
      dir:find('fugitive://') == nil and
      dir:find('term://') == nil
    )
end

function _G.save_view_settings()
    if should_persist_view() then
        vim.cmd('mkview!')
    end
end

function _G.load_view_settings()
    if should_persist_view() then
        vim.cmd('silent! loadview')
    end
end

vim.api.nvim_exec([[
augroup remember_folds
	au!
	au BufWinLeave * lua save_view_settings()
	au BufWinEnter * lua load_view_settings()
augroup END
]], false)

-- Jump to the last position on load
vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]])

vim.wo.foldminlines = 4
vim.wo.foldnestmax = 3
vim.o.foldopen = 'block,hor,mark,percent,quickfix,search,tag,undo,jump'

function _G.adjust_qf_height(minheight, maxheight)
    local height = math.max(math.min(vim.fn.line('$'), maxheight), minheight)
    vim.api.nvim_win_set_height(height)
end

-- Keep the quickfix window small when there aren't many lines
vim.cmd('au FileType qf call v:lua.adjust_qf_height(3, 10)')

--------------------------------------------------------------
-- Colour settings
--------------------------------------------------------------

vim.cmd('hi Pmenu ctermbg=Blue')
vim.cmd('hi clear Conceal')

-- vim.g.rehash256 = 1
-- vim.cmd('colorscheme molokai')
vim.cmd('colorscheme onedark')
vim.o.background = 'dark'
vim.o.termguicolors = true

vim.cmd([[au TextYankPost * lua vim.highlight.on_yank { timeout = 500 }]])

function _G.git_sl()
    if vim.fn.exists('fugitive#head') then
        return ''
    end

    local head = vim.fn['fugitive#head']()
    if head ~= '' then
        return ' @ ' .. head
    end
    return ''
end

-- clear the statusline for when vimrc is reloaded
vim.o.statusline = table.concat({
    '[%n] ',         -- buffer number
    '%<%.99f',       -- file name
    '%{v:lua.git_sl()} ',
    '%h%m%r%w%q',    -- flags
    '%=',            -- right align
    '%y ',           -- file type
    '%-8( %l,%c %)', -- offset
})

vim.api.nvim_exec([[
tnoremap <M-h> <C-\><C-n><C-w>h
tnoremap <M-j> <C-\><C-n><C-w>j
tnoremap <M-k> <C-\><C-n><C-w>k
tnoremap <M-l> <C-\><C-n><C-w>l

autocmd BufWinEnter,WinEnter term://* startinsert
autocmd BufLeave term://* stopinsert

command! Vterm vertical belowright split | term
]], false)

vim.o.inccommand = 'nosplit'

--------------------------------------------------------------
-- Plug-ins
--------------------------------------------------------------

local local_vimrc = vim.fn.expand('~/.vimrc.local')
if vim.fn.filereadable(local_vimrc) == 1 then
    vim.cmd('source ' .. local_vimrc)
end

local function isModuleAvailable(name)
  if package.loaded[name] then
    return true
  else
    for _, searcher in ipairs(package.searchers or package.loaders) do
      local loader = searcher(name)
      if type(loader) == 'function' then
        package.preload[name] = loader
        return true
      end
    end
    return false
  end
end

for _, plugin in ipairs(vim.g.plugs_order) do
  local plugin_path = 'nikklassen.plugin_config.' .. plugin:gsub([[%.]], '_')
  if isModuleAvailable(plugin_path) then
    local mod = require(plugin_path)
    if type(mod) ~= 'table' then
      vim.api.nvim_err_writeln(plugin .. ' is not a module')
    else
      local status, err = pcall(mod.configure)
      if not status then
        vim.api.nvim_err_writeln(string.format('failed to load %s config: %s', plugin , err))
      end
    end
  end
end
