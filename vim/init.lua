vim.o.compatible = false

vim.g.python_host_prog = '/usr/bin/python'
vim.g.python3_host_prog = '/usr/bin/python3'

require'plugins'

-- Better command-line completion
vim.o.wildmode = 'list:longest,full'

vim.o.wildignore = '*.o,*.pyc,*.hi'

-- Completion settings
vim.o.completeopt = 'menuone,noinsert,noselect'
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
vim.o.shiftwidth = 4
vim.o.softtabstop = 4
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

local function PersistViewForFile()
    return vim.fn.expand('%:t') ~= '' and string.find(vim.fn.expand('%:p'), 'fugitive://') == nil
end

local function SaveViewSettings()
    if PersistViewForFile() then
        vim.cmd('mkview!')
    end
end

local function LoadViewSettings()
    if PersistViewForFile() then
        vim.cmd('silent loadview')
    end
end

if vim.fn.has('nvim') == 0 then
    vim.cmd('au BufWinLeave * lua SaveViewSettings()')
    vim.cmd('au BufWinEnter * lua LoadViewSettings()')

    -- Hold onto marks for the last ten files
    vim.o.viminfo = "'10"
else
    -- Jump to the last position on load
    vim.cmd([[au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g`\"" | endif]])
end

--------------------------------------------------------------
-- Colour settings
--------------------------------------------------------------

vim.cmd('hi Pmenu ctermbg=Blue')
vim.cmd('hi clear Conceal')

vim.o.background = 'dark'
vim.g.rehash256 = 1
vim.cmd('colorscheme molokai')

vim.api.nvim_exec([[
function! GitSL()
    if exists('fugitive#head')
        return ''
    endif

    let head = fugitive#head()
    if head != ''
        return ' @ ' . head
    endif
    return ''
endfunction
]], false)

-- clear the statusline for when vimrc is reloaded
vim.o.statusline = table.concat({
    '[%n] ',         -- buffer number
    '%<%.99f',       -- file name
    '%{GitSL()} ',
    '%h%m%r%w%q',    -- flags
    '%=',            -- right align
    '%y ',           -- file type
    '%-8( %l,%c %)', -- offset
})

-- Keep the quickfix window small when there aren't many lines
vim.cmd('au FileType qf call AdjustWindowHeight(3, 10)')
local function AdjustWindowHeight(minheight, maxheight)
    vim.cmd('exe max([min([line("$"), a:maxheight]), a:minheight]) . "wincmd _"')
end

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
    local plugin_path = 'plugin_config.' .. plugin:gsub([[%.]], '_')
    if isModuleAvailable(plugin_path) then
        require(plugin_path)
    end
end
