if vim.loop.fs_stat(vim.loop.os_getenv('HOME') .. '/.vim.local') then
    return {
        { import = 'local' },
    }
else
    return {}
end
