-- Better command-line completion
vim.o.wildmode = 'list:longest,full'

vim.o.wildignore = '*.o,*.pyc,*.hi'

-- Completion settings
vim.o.completeopt = 'menu,menuone,noinsert'
if vim.fn.has("nvim-0.11.0") == 1 then
  vim.o.completeopt = vim.o.completeopt .. ',fuzzy'
end
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

-- Hide status messages
vim.o.cmdheight = 0

-- Display line numbers on the left
vim.wo.relativenumber = true
vim.wo.signcolumn = 'yes'

-- Shorter timeout for escape keys
vim.o.tm = 250

vim.o.concealcursor = 'n'
vim.o.conceallevel = 0

vim.o.path = '.,/usr/include,,'

vim.o.hidden = true

vim.o.list = true

vim.o.mouse = 'a'

vim.o.spelloptions = 'camel'

vim.o.updatetime = 1000

--------------------------------------------------------------
-- Indentation options
--------------------------------------------------------------
vim.o.shiftwidth = 2
vim.o.softtabstop = 2
vim.o.tabstop = 2

vim.o.expandtab = true
vim.o.shiftround = true
vim.o.joinspaces = false

vim.o.diffopt = vim.o.diffopt .. ',followwrap'

-- Disable health checks for languages I don't care about
vim.g.loaded_ruby_provider = 0
vim.g.loaded_node_provider = 0
vim.g.loaded_perl_provider = 0

vim.g.netrw_altfile = 1
