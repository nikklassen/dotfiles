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

