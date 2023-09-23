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

function M.string_split(inputstr, sep)
    if sep == nil then
        sep = "%s"
    end
    local t = {}
    for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
        table.insert(t, str)
    end
    return t
end

function M.lazy_require(module)
    return setmetatable({}, {
        __index = function(_, key)
            return function(...)
                return require(module)[key](...)
            end
        end
    })
end

return M
