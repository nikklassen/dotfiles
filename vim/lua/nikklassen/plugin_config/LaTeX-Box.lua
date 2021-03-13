local M = {}

function M.configure()
    vim.g.LatexBox_viewer = 'open -a Skim'
    vim.g.LatexBox_autojump = 1
    vim.g.LatexBox_latexmk_async = 1
    vim.g.LatexBox_latexmk_preview_continuously = 1
    vim.g.LatexBox_quickfix = 2
    vim.g.LatexBox_complete_inlineMath = 1
end

return M
