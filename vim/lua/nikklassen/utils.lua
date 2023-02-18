local M = {}

function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, {...})
  print(unpack(objects))
end

function M.tbl_list_extend(tbl1, tbl2)
    if tbl2 == nil then
        return
    end
    for _, value in ipairs(tbl2) do
        tbl1[#tbl1+1] = value
    end
    return tbl1
end

function M.isModuleAvailable(name)
  if package.loaded[name] then
    return true
  end
  for _, searcher in ipairs(package.searchers or package.loaders) do
    local loader = searcher(name)
    if type(loader) == 'function' then
      package.preload[name] = loader
      return true
    end
  end
  return false
end

return M
