-- Better command-line completion
vim.o.wildmode = 'list:longest,full'

vim.o.wildignore = '*.o,*.pyc,*.hi'

-- Completion settings
vim.o.completeopt = 'menuone,noselect'
vim.o.shortmess = vim.o.shortmess .. 'c'
vim.o.pumheight = 10

-- Show partial commands in the last line of the screen
vim.o.showcmd = true

-- Search commands
vim.o.hlsearch = true
vim.o.ignorecase = true
vim.o.smartcase = true

vim.o.smartindent = true

vim.o.inccommand = 'nosplit'

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
vim.wo.signcolumn = 'yes'

-- Shorter timeout for escape keys
vim.o.tm=250

vim.o.concealcursor = 'n'
vim.o.conceallevel=0

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

vim.cmd('autocmd BufReadPost * if &diff | setlocal wrap | endif')