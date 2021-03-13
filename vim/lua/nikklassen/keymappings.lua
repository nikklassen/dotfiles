local M = {}

-- Search for the currently selected text
vim.api.nvim_set_keymap('v', '//', [["sy/<C-r>s<CR>]], {
	noremap = true,
})

return M
