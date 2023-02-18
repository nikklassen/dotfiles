local utils = require'nikklassen.utils'

local packer_install_path = vim.fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
local packer_did_bootstrap = false
if vim.fn.isdirectory(packer_install_path) == 0 then
    packer_did_bootstrap = vim.fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', packer_install_path})
end

local packer_user_config_ag = vim.api.nvim_create_augroup('packer_user_config', {})
vim.api.nvim_create_autocmd('BufWritePost', {
    group = packer_user_config_ag,
    pattern = {'plugins.lua'},
    command = 'source <afile> | PackerCompile'
})

vim.cmd [[packadd packer.nvim]]

local packer = require'packer'
packer.startup(function (use)
    -- Packer can manage itself
    use 'wbthomason/packer.nvim'

    use 'tpope/vim-sensible'

    use {'Raimondi/delimitMate', config = function() require'nikklassen.plugin_config.delimitMate'.configure() end}

    use {'embear/vim-localvimrc', config = function() require'nikklassen.plugin_config.vim-localvimrc'.configure() end}
    use {
        'scrooloose/nerdtree',
        opt = true,
        cmd = {'NERDTreeToggle', 'NERDTreeFind'},
        config = function() require'nikklassen.plugin_config.nerdtree'.configure() end,
    }

    use {'joshdick/onedark.vim', config = [[vim.cmd('colorscheme onedark')]]}
    use 'tpope/vim-fugitive'
    use 'tpope/vim-surround'
    use 'tpope/vim-repeat'
    use 'tpope/vim-commentary'
    use 'tpope/vim-abolish'
    use {'whiteinge/diffconflicts', opt = true, cmd = {'DiffConflicts'}}
    use 'vim-scripts/ReplaceWithRegister'

    use {
        'ibhagwan/fzf-lua',
        requires = {'junegunn/fzf', run = './install --bin'},
        config = function () require 'nikklassen.plugin_config.fzf_lua'.configure() end,
    }

    use {'rking/ag.vim', config = function() require'nikklassen.plugin_config.ag_vim'.configure() end}

    use 'ludovicchabant/vim-lawrencium'

    ---------------------
    -- Language plugins -
    ---------------------

    -- JQ
    use {'vito-c/jq.vim', ft = 'jq'}

    -- Rust
    use {'rust-lang/rust.vim', ft = 'rust'}

    -- Markdown
    use {
        'dhruvasagar/vim-table-mode',
        ft = {'pandoc', 'markdown'},
        config = function() require'nikklassen.plugin_config.vim-table-mode'.configure() end,
    }

    -- HTML
    use {'mattn/emmet-vim', ft = {'html', 'htmldjango', 'xml', 'eruby'}}
    use {'othree/xml.vim', ft = {'xml', 'html', 'eruby'}}
    use {'othree/html5.vim', ft = {'html', 'eruby'}}

    -- Go
    use {
        'sebdah/vim-delve',
        ft = 'go',
        config = function() require'nikklassen.plugin_config.vim-delve'.configure() end,
    }

    -------------------
    -- Other plugins --
    -------------------

    use {'brettanomyces/nvim-editcommand', config = function() require'nikklassen.plugin_config.nvim-editcommand'.configure() end}

    use {'neovim/nvim-lspconfig', config = function() require'nikklassen.plugin_config.nvim-lspconfig'.configure() end}

    use {'hrsh7th/nvim-cmp', branch = 'main', config = function() require'nikklassen.plugin_config.nvim-cmp'.configure() end}
    use {'hrsh7th/cmp-nvim-lsp', branch = 'main'}
    use {
        'hrsh7th/cmp-vsnip',
        branch = 'main',
        requires = {'hrsh7th/nvim-cmp'},
    }
    use 'hrsh7th/vim-vsnip'
    use {'hrsh7th/cmp-nvim-lsp-signature-help', branch = 'main'}
    -- VSCode plugin, imported just for the snippets
    use 'golang/vscode-go'

    -- Coq, alternative to nvim-cmp, but doesn't work as well
    -- plug('ms-jpq/coq_nvim', {branch = 'coq'})
    -- plug('ms-jpq/coq.artifacts', {branch= 'artifacts'})

    use {'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function() require'nikklassen.plugin_config.nvim-treesitter'.configure() end}
    use {
        'nvim-treesitter/playground',
        requires = {'nvim-treesitter/nvim-treesitter'}
    }
    use {
        'nvim-treesitter/nvim-treesitter-textobjects',
        requires = {'nvim-treesitter/nvim-treesitter'}
    }

    use {'ojroques/vim-oscyank', branch = 'main'}

    use 'RishabhRD/popfix'
    use 'RishabhRD/nvim-lsputils'

    if vim.fn.has('win32') == 0 then
        use 'tpope/vim-eunuch'
    end

    use 'nvim-lua/plenary.nvim'

    if utils.isModuleAvailable('local') then
        local local_config = require'local'
        if local_config.packer_startup ~= nil then
            local_config.packer_startup(use)
        end
    end

    -- Automatically set up your configuration after cloning packer.nvim
    -- Put this at the end after all plugins
    if packer_did_bootstrap then
        packer.sync()
    end
end)

