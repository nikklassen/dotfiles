return {
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        dependencies = {
            { 'nvim-telescope/telescope-fzf-native.nvim', build = 'make' },
        },
        opts = {},
        main = 'nikklassen.telescope',
    },
}
