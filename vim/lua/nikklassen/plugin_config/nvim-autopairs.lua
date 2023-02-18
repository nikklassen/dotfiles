local npairs = require("nvim-autopairs")

local M = {}

function M.configure()
    npairs.setup({
        check_ts = true,
        enable_check_bracket_line = false,
    })
end

return M
