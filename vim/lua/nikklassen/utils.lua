local M = {}

function _G.dump(...)
    local objects = vim.tbl_map(vim.inspect, { ... })
    print(unpack(objects))
end

function M.tbl_list_extend(tbl1, tbl2)
    if tbl2 == nil then
        return
    end
    for _, value in ipairs(tbl2) do
        tbl1[#tbl1 + 1] = value
    end
    return tbl1
end

function M.has_plugin(plugin)
    return M.get_plugin(plugin) ~= nil
end

function M.get_plugin(plugin)
    return require('lazy.core.config').spec.plugins[plugin]
end

return M
