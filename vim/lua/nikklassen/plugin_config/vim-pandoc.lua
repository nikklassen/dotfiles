return {
  configure = function()
    vim.g['pandoc#modules#disabled'] = {'formatting'}
    vim.g['pandoc#syntax#conceal#use'] = 0
    vim.g['pandoc#syntax#codeblocks#embeds#langs'] = {'java', 'c'}
    vim.g['pandoc#command#autoexec_command'] = 'Pandoc pdf -d markdown'
    vim.g['pandoc#formatting#mode'] = 'ha'
    if vim.fn.executable('pandoc') == 1 then
      vim.g['pandoc#command#autoexec_on_writes'] = 1
    end
  end
}
