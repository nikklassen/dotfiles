local M = {}

function _G.dump(...)
  local objects = vim.tbl_map(vim.inspect, { ... })
  print(unpack(objects))
end

if vim.uv then
  M.uv = vim.uv
else
  M.uv = vim.loop
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

---Finds an element of a list matching a predicate
---@generic T
---@param pred fun(e: T): boolean
---@param tbl T[]
---@return T | nil
---@return boolean
function M.list_find(pred, tbl)
  for _, e in ipairs(tbl) do
    if pred(e) then
      return e, true
    end
  end
  return nil, false
end

function M.string_split(inputstr, sep)
  if sep == nil then
    sep = '%s'
  end
  local t = {}
  for str in string.gmatch(inputstr, '([^' .. sep .. ']+)') do
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
    end,
    __call = function(...)
      return require(module)(...)
    end,
  })
end

local function get_key_mapping(keys, target)
  for i, key in ipairs(keys) do
    if key[1] == target[1] then
      return i
    end
  end
  return nil
end

function M.merge_keys(behaviour, dst, src)
  for _, key in ipairs(src) do
    local existing = get_key_mapping(dst, key)
    if existing ~= nil then
      if behaviour == 'force' then
        dst[existing] = key
      end
    else
      dst[#dst + 1] = key
    end
  end
  return dst
end

function M.is_cwd_readable()
  local cwd, err = M.uv.cwd()
  if err then
    return false
  end
  return vim.fn.isdirectory(cwd) == 1
end

function string:starts_with(prefix)
  return self:sub(1, #prefix) == prefix
end

function M.wrap_notify_on_error(f)
  return function(...)
    local ok, err = pcall(f, ...)
    if not ok then
      vim.notify(err, vim.log.levels.ERROR)
    end
  end
end

return M
