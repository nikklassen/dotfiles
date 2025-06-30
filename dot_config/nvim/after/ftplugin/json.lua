vim.opt_local.winbar = "%{%v:lua.require'jsonpath'.get()%}"
vim.keymap.set("n", "<leader>yp", function()
  vim.fn.setreg("+", require("jsonpath").get())
end, { desc = "copy json path", buffer = true })
